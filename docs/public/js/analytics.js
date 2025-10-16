function addTrackingToNav() {
  const links = [
    {
      els: Array.from(
        document.querySelectorAll('.navbar-items a[aria-label="Changelog"]'),
      ),
      fathomTrackedEventId: "", // "1IM3F81U",
      umamiTrackedEventId: "Click navbar Changelog link",
    },
    {
      els: Array.from(
        document.querySelectorAll('.navbar-items a[aria-label="License"]'),
      ),
      fathomTrackedEventId: "", // "FLLTLBBH",
      umamiTrackedEventId: "Click navbar License link",
    },
    {
      els: Array.from(
        document.querySelectorAll('.navbar-items a[aria-label="GitHub"]'),
      ),
      fathomTrackedEventId: "", // "UDQTYUYT",
      umamiTrackedEventId: "Click navbar GitHub link",
    },
  ];

  for (const link of links) {
    link.els.forEach((el) => {
      link.fathomTrackedEventId != ""
        ? el.setAttribute(
            "data-track-fathom-event-id",
            link.fathomTrackedEventId,
          )
        : "";

      el.setAttribute("data-track-umami-event-id", link.umamiTrackedEventId);
    });
  }
}

function trackLinks() {
  const links = document.getElementsByTagName("a");

  for (const link of links) {
    const fathomTrackedEventId = link.getAttribute(
      "data-track-fathom-event-id",
    );

    const umamiTrackedEventId = link.getAttribute("data-track-umami-event-id");

    if (trackedEventId && window?.fathom) {
      link.addEventListener("click", () => {
        // window.fathom?.trackGoal(fathomTrackedEventId, 0);
      });
    }

    if (trackedEventId && window?.umami) {
      link.addEventListener("click", () => {
        window.umami?.track(umamiTrackedEventId);
      });
    }
  }
}

function trackSearch() {
  const containerEls = document.getElementsByClassName("DocSearch-Container");
  const hitEls = document.getElementsByClassName("DocSearch-Hit");
  const openAttribute = "data-docsearch-container-open";

  function watchContainerEls() {
    /**
     * if was open and is open, do nothing
     * if was open and is closed, remove attribute
     * if was closed and is open, add attribute
     */

    const wasOpen = document.documentElement.hasAttribute(openAttribute);
    const isOpen = containerEls.length > 0;

    if (wasOpen) {
      if (!isOpen) {
        // closed
        document.documentElement.removeAttribute(openAttribute);
        // window?.fathom?.trackGoal("OBGWG9QM", 0);
        window?.umami?.track("Close search dialog");
      }

      return;
    }

    if (!isOpen) {
      return;
    }

    // opened
    document.documentElement.setAttribute(openAttribute, "");
    // window?.fathom?.trackGoal("LGQFSSLL", 0);
    window?.umami?.track("Open search dialog");
  }

  function watchHitEls() {
    for (const hitEl of hitEls) {
      // const text = hitEl.querySelector('.DocSearch-Hit-title').innerText || ''

      hitEl.querySelector("a").addEventListener("click", () => {
        document.documentElement.removeAttribute(openAttribute);

        // window?.fathom?.trackGoal("ULRIYLIO", 0);
        window?.umami?.track("Click search dialog hit");
      });
    }
  }

  const observer = new MutationObserver(() => {
    watchContainerEls();
    watchHitEls();
  });

  observer.observe(document, { childList: true, subtree: true });
}

// "if not dev mode"
if (window?.fathom?.trackGoal || window?.umami?.track) {
  addTrackingToNav();
  trackLinks();
  trackSearch();
}
