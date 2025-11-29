// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import "./controllers/modal"

// === NeighborFood Navbar Toggle ===
document.addEventListener("turbo:load", () => {
  const toggle = document.querySelector('[data-action="toggle-menu"]');
  const menu   = document.querySelector('[data-target="menu"]');

  if (!toggle || !menu) return;

  // Open / close mobile menu
  const setOpen = (open) => {
    toggle.setAttribute("aria-expanded", String(open));
    menu.classList.toggle("is-open", open);
  };

  toggle.addEventListener("click", () => {
    const open = toggle.getAttribute("aria-expanded") !== "true";
    setOpen(open);
  });

  // Optional: close menu when clicking a link (for mobile)
  menu.querySelectorAll("a").forEach(a => {
    a.addEventListener("click", () => setOpen(false));
  });
});
