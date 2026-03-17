/**
 * Argo CD AI Recommendations Tab Extension
 *
 * Registers an application view extension that fetches and displays MCP-backed
 * recommendations via the Argo CD Proxy Extension.
 *
 * Headers sent: Argocd-Application-Name (namespace:app-name), Argocd-Project-Name
 * Endpoint: /extensions/ai-recommendations/recommendations
 *
 * Reference: https://argo-cd.readthedocs.io/en/stable/developer-guide/extensions/
 */

(function () {
  if (typeof extensionsAPI === 'undefined') {
    console.warn('Argo CD extensionsAPI not available');
    return;
  }

  const RecommendationView = function (props) {
    const app = props.application || props.app || {};
    const appName = app.metadata && app.metadata.name ? app.metadata.name : 'unknown';
    const namespace = app.metadata && app.metadata.namespace ? app.metadata.namespace : 'argocd';
    const projectName = app.spec && app.spec.project ? app.spec.project : 'default';

    const appNameHeader = namespace + ':' + appName;

    const [state, setState] = React.useState({
      loading: true,
      recommendations: [],
      error: null,
    });

    React.useEffect(
      function () {
        setState({ loading: true, recommendations: [], error: null });

        const url = getApiBase() + '/extensions/ai-recommendations/recommendations';
        fetch(url, {
          method: 'GET',
          credentials: 'include',
          headers: {
            'Argocd-Application-Name': appNameHeader,
            'Argocd-Project-Name': projectName,
          },
        })
          .then(function (res) {
            if (!res.ok) throw new Error('Failed to fetch recommendations: ' + res.status);
            return res.json();
          })
          .then(function (data) {
            setState({
              loading: false,
              recommendations: data.recommendations || [],
              error: null,
            });
          })
          .catch(function (err) {
            setState({
              loading: false,
              recommendations: [],
              error: err.message || 'Unknown error',
            });
          });
      },
      [appNameHeader, projectName]
    );

    return React.createElement(
      'div',
      { className: 'ai-recommendations-tab', style: styles.container },
      React.createElement('h3', { style: styles.title }, 'AI Recommendations'),
      React.createElement(
        'p',
        { style: styles.subtitle },
        'Application: ',
        appName,
        ' \u2022 Project: ',
        projectName
      ),
      state.loading
        ? React.createElement('div', { style: styles.loading }, 'Loading recommendations...')
        : state.error
          ? React.createElement(
              'div',
              { style: styles.error },
              React.createElement('span', { className: 'fa fa-exclamation-triangle', style: { marginRight: '8px' } }),
              state.error,
              React.createElement(
                'p',
                { style: styles.errorHint },
                'Ensure the Proxy Extension is configured and the MCP backend is running.'
              )
            )
          : state.recommendations.length === 0
            ? React.createElement('div', { style: styles.empty }, 'No recommendations for this application.')
            : React.createElement(
                'div',
                { style: styles.list },
                state.recommendations.map(function (rec, i) {
                  return React.createElement(RecommendationCard, { key: i, recommendation: rec });
                })
              )
    );
  };

  function RecommendationCard(props) {
    const rec = props.recommendation;
    const severityColor =
      rec.severity === 'warning'
        ? '#f0ad4e'
        : rec.severity === 'error'
          ? '#d9534f'
          : '#5bc0de';
    const typeIcon =
      rec.type === 'health'
        ? 'fa-heartbeat'
        : rec.type === 'optimization'
          ? 'fa-tachometer-alt'
          : 'fa-wrench';

    return React.createElement(
      'div',
      {
        className: 'ai-recommendation-card',
        style: {
          ...styles.card,
          borderLeftColor: severityColor,
        },
      },
      React.createElement(
        'div',
        { style: styles.cardHeader },
        React.createElement('span', { className: 'fa ' + typeIcon, style: { ...styles.icon, color: severityColor } }),
        React.createElement('span', { style: styles.cardType }, rec.type),
        React.createElement('span', { style: { ...styles.badge, backgroundColor: severityColor } }, rec.severity)
      ),
      React.createElement('h4', { style: styles.cardTitle }, rec.title),
      React.createElement('p', { style: styles.cardDesc }, rec.description),
      rec.action
        ? React.createElement(
            'p',
            { style: styles.cardAction },
            React.createElement('strong', null, 'Action: '),
            rec.action
          )
        : null
    );
  }

  function getApiBase() {
    if (typeof window !== 'undefined' && window.location) {
      var base = window.location.pathname;
      if (base.indexOf('/applications/') !== -1) {
        base = base.substring(0, base.indexOf('/applications/'));
      } else if (base.endsWith('/')) {
        base = base.slice(0, -1);
      }
      return base || '';
    }
    return '';
  }

  var styles = {
    container: { padding: '1rem', maxWidth: '800px' },
    title: { marginBottom: '0.25rem', fontWeight: 600 },
    subtitle: { color: '#888', fontSize: '0.9em', marginBottom: '1rem' },
    loading: { color: '#888', padding: '2rem', textAlign: 'center' },
    error: {
      color: '#d9534f',
      padding: '1rem',
      backgroundColor: '#fdf2f2',
      borderRadius: '4px',
      border: '1px solid #f5c6cb',
    },
    errorHint: { marginTop: '0.5rem', fontSize: '0.85em', color: '#666' },
    empty: { color: '#888', padding: '2rem', textAlign: 'center' },
    list: { display: 'flex', flexDirection: 'column', gap: '1rem' },
    card: {
      padding: '1rem',
      backgroundColor: '#fff',
      border: '1px solid #e0e0e0',
      borderRadius: '6px',
      borderLeft: '4px solid #5bc0de',
    },
    cardHeader: { display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '0.5rem' },
    icon: { width: '16px', textAlign: 'center' },
    cardType: {
      textTransform: 'capitalize',
      fontSize: '0.75em',
      color: '#666',
      fontWeight: 600,
    },
    badge: {
      marginLeft: 'auto',
      fontSize: '0.7em',
      padding: '2px 6px',
      borderRadius: '4px',
      color: '#fff',
      textTransform: 'capitalize',
    },
    cardTitle: { margin: '0 0 0.5rem 0', fontSize: '1em', fontWeight: 600 },
    cardDesc: { margin: '0 0 0.5rem 0', color: '#444', fontSize: '0.9em', lineHeight: 1.5 },
    cardAction: { margin: 0, fontSize: '0.85em', color: '#666', fontStyle: 'italic' },
  };

  extensionsAPI.registerAppViewExtension(RecommendationView, 'AI Recommendations', 'fa fa-robot');
})();
