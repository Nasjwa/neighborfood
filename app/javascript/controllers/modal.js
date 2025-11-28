document.addEventListener("DOMContentLoaded", () => {
  const btn = document.getElementById("open-map-btn");
  const modal = document.getElementById("map-modal");
  const closeBtn = document.getElementById("close-map-modal");
  const mobileSearchTab = document.getElementById("mobile-search-tab");

  // Desktop button
  if (btn) {
    btn.addEventListener("click", (e) => {
      e.preventDefault();
      modal.classList.remove("hidden");

      setTimeout(() => {
        if (window.myMap) window.myMap.resize();
      }, 200);
    });
  }

  // Mobile Search Tab → opens the modal
  if (window.innerWidth < 768 && mobileSearchTab) {
    mobileSearchTab.addEventListener("click", (e) => {
      e.preventDefault();
      modal.classList.remove("hidden");

      setTimeout(() => {
        if (window.myMap) window.myMap.resize();
      }, 200);
    });
  }

  // Close modal
  if (closeBtn) {
    closeBtn.addEventListener("click", () => {
      modal.classList.add("hidden");
    });
  }

  modal.addEventListener("click", (event) => {
    if (event.target === modal) {
      modal.classList.add("hidden");
    }
  });
});
