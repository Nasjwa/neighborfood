function initModals() {

  // CLAIM MODAL (index + show)

  const claimModal = document.getElementById("claim-modal");
  const claimModalBody = document.getElementById("claim-modal-body");

  // Open modal from any claim button
  document.addEventListener("click", (e) => {
    const btn = e.target.closest("[data-claim-modal='true']");
    if (!btn || !claimModal || !claimModalBody) return;

    e.preventDefault();

    let template = null;

    // Index page open 
    const card = btn.closest(".nf-card");
    if (card) {
      template = card.querySelector(".claim-template");
    }

    // Show page open
    if (!template) {
      template = document.getElementById("claim-template-show");
    }

    if (!template) return;

    claimModalBody.innerHTML = template.innerHTML;
    claimModal.classList.remove("hidden");
  });

  // CLOSE claim modal "Close" button
  document.addEventListener("click", (e) => {
    if (!claimModal) return;

    if (e.target.closest("#close-claim-modal")) {
      claimModal.classList.add("hidden");
      claimModalBody.innerHTML = "";
    }
  });

  // Close modal by clicking the background
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

  // Open map from navbar button
  document.addEventListener("click", (e) => {
    const btn = e.target.closest("#open-map-btn");
    if (!btn || !mapModal) return;

    e.preventDefault();
    mapModal.classList.remove("hidden");

    setTimeout(() => window.myMap?.resize(), 200);
  });

  // Open map from mobile tab
  document.addEventListener("click", (e) => {
    const btn = e.target.closest("#mobile-search-tab");
    if (!btn || !mapModal) return;

    e.preventDefault();
    mapModal.classList.remove("hidden");

    setTimeout(() => window.myMap?.resize(), 200);
  });

  // Close map modal (X button)
  document.addEventListener("click", (e) => {
    if (e.target.closest("#close-map-modal")) {
      mapModal?.classList.add("hidden");
    }
  });

  // Close map modal by clicking background
  if (mapModal) {
    mapModal.addEventListener("click", (e) => {
      if (e.target === mapModal) {
        mapModal.classList.add("hidden");
      }
    });
  }
}

document.addEventListener("DOMContentLoaded", initModals);
document.addEventListener("turbo:load", initModals);
