function initModals() {

  // ============================
  // CLAIM MODAL (index + show)
  // ============================
  const claimModal = document.getElementById("claim-modal");
  const claimModalBody = document.getElementById("claim-modal-body");

  document.addEventListener("click", async (e) => {
    const btn = e.target.closest("[data-claim-modal-url]");
    if (!btn) return;

    e.preventDefault();

    const url = btn.dataset.claimModalUrl;
    if (!url) return;

    const response = await fetch(url, {
      headers: { "Accept": "text/vnd.turbo-stream.html" }
    });

    const html = await response.text();
    claimModalBody.innerHTML = html;

    claimModal.classList.remove("hidden");
  });

  // CLOSE claim modal
  document.addEventListener("click", (e) => {
    if (e.target.closest("#close-claim-modal")) {
      claimModal.classList.add("hidden");
      claimModalBody.innerHTML = "";
    }
  });

  if (claimModal) {
    claimModal.addEventListener("click", (e) => {
      if (e.target === claimModal) {
        claimModal.classList.add("hidden");
        claimModalBody.innerHTML = "";
      }
    });
  }



  // ============================
  // MAP MODAL
  // ============================
  const mapModal = document.getElementById("map-modal");

  document.addEventListener("click", (e) => {
    const btn = e.target.closest("#open-map-btn");
    if (!btn || !mapModal) return;

    e.preventDefault();
    mapModal.classList.remove("hidden");

    setTimeout(() => window.myMap?.resize(), 200);
  });

  document.addEventListener("click", (e) => {
    const btn = e.target.closest("#mobile-search-tab");
    if (!btn || !mapModal) return;

    e.preventDefault();
    mapModal.classList.remove("hidden");

    setTimeout(() => window.myMap?.resize(), 200);
  });

  document.addEventListener("click", (e) => {
    if (e.target.closest("#close-map-modal")) {
      mapModal?.classList.add("hidden");
    }
  });

  if (mapModal) {
    mapModal.addEventListener("click", (e) => {
      if (e.target === mapModal) {
        mapModal.classList.add("hidden");
      }
    });
  }
}


// Ensures running with Turbo + DOM
document.addEventListener("DOMContentLoaded", initModals);
document.addEventListener("turbo:load", initModals);
