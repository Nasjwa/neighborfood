function initModals() {
  
  // CLAIM MODAL (index + show)
  const claimModal = document.getElementById("claim-modal");
  const claimModalBody = document.getElementById("claim-modal-body");
  const closeClaimBtn = document.getElementById("close-claim-modal");

  // Open modal from any claim button
  document.addEventListener("click", (e) => {
    const btn = e.target.closest("[data-claim-modal='true']");
    if (!btn || !claimModal || !claimModalBody) return;

    e.preventDefault();

    let template = null;

    // Index page claim modal
    const card = btn.closest(".nf-card");
    if (card) {
      template = card.querySelector(".claim-template");
    }

    // Show page modal
    if (!template) {
      const showTemplate = document.getElementById("claim-template-show");
      if (showTemplate) {
        template = showTemplate;
      }
    }

    claimModalBody.innerHTML = template.innerHTML;
    claimModal.classList.remove("hidden");
  });

  // Close with button
  if (closeClaimBtn) {
    closeClaimBtn.addEventListener("click", () => {
      claimModal.classList.add("hidden");
      claimModalBody.innerHTML = "";
    });
  }

  // Close clicking outside
  if (claimModal) {
    claimModal.addEventListener("click", (e) => {
      if (e.target === claimModal) {
        claimModal.classList.add("hidden");
        claimModalBody.innerHTML = "";
      }
    });
  }

  // MAP MODAL
  const mapModal = document.getElementById("map-modal");
  const closeMapBtn = document.getElementById("close-map-modal");

  // Desktop button
  document.addEventListener("click", (e) => {
    const btn = e.target.closest("#open-map-btn");
    if (!btn || !mapModal) return;
    e.preventDefault();

    mapModal.classList.remove("hidden");
    setTimeout(() => window.myMap?.resize(), 200);
  });

  // Mobile tab
  document.addEventListener("click", (e) => {
    const btn = e.target.closest("#mobile-search-tab");
    if (!btn || !mapModal) return;
    e.preventDefault();

    mapModal.classList.remove("hidden");
    setTimeout(() => window.myMap?.resize(), 200);
  });

  // Close map button
  if (closeMapBtn) {
    closeMapBtn.addEventListener("click", () => {
      mapModal.classList.add("hidden");
    });
  }

  // Close map by clicking outside
  if (mapModal) {
    mapModal.addEventListener("click", (e) => {
      if (e.target === mapModal) mapModal.classList.add("hidden");
    });
  }
}

document.addEventListener("DOMContentLoaded", initModals);

document.addEventListener("turbo:load", initModals);
