export default ({ $config }) => {
  if (process.client && $config.matomoHost && $config.matomoSiteId) {
    // Dynamically load Matomo script
    (function() {
      var u = $config.matomoHost
      window._paq = window._paq || []
      window._paq.push(['setSiteId', $config.matomoSiteId])
      window._paq.push(['setTrackerUrl', u + 'matomo.php'])
      window._paq.push(['trackPageView'])
      window._paq.push(['enableLinkTracking'])
      var d = document, g = d.createElement('script'), s = d.getElementsByTagName('script')[0]
      g.async = true; g.src = u + 'matomo.js'; s.parentNode.insertBefore(g, s)
    })()
  }
}
