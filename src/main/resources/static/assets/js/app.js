/*
Template Name: Urbix - Admin & Dashboard Template
Author: Pixeleyez
Website: https://pixeleyez.com/
File: app js
*/

// Initialize Bootstrap tooltips and popovers
function initializeBootstrapComponents(selector, Component) {
  const triggerList = document.querySelectorAll(selector);
  return [...triggerList].map((triggerEl) => new Component(triggerEl));
}

// Initialize tooltips
const tooltips = initializeBootstrapComponents(
  '[data-bs-toggle="tooltip"]',
  bootstrap.Tooltip
);

// Initialize popovers
const popovers = initializeBootstrapComponents(
  '[data-bs-toggle="popover"]',
  bootstrap.Popover
);

// Function to handle both sticky menu and button loading
function initializeAppFeatures() {
  const stickyMenu = document.getElementById("appHeader"); // Ensure this ID matches your HTML
  const stickyOffset = stickyMenu.offsetTop;

  // Function to toggle sticky class on scroll
  function toggleStickyMenu() {
    if (window.scrollY > stickyOffset) {
      stickyMenu.classList.add("sticky-scroll");
    } else {
      stickyMenu.classList.remove("sticky-scroll");
    }
  }

  // Attach the scroll event listener
  window.addEventListener("scroll", toggleStickyMenu);

  // Attach click event listeners to all loader buttons
  document.querySelectorAll(".btn-loader").forEach((button) => {
    button.addEventListener("click", function () {
      const indicatorLabel = this.querySelector(".indicator-label");
      const originalText = indicatorLabel.textContent;
      const loadingText = this.getAttribute("data-loading-text");

      // Show loading indicator and disable button
      this.classList.add("loading");
      indicatorLabel.textContent = loadingText;
      this.disabled = true;

      // Simulate an asynchronous operation (e.g., form submission)
      setTimeout(() => {
        // Hide loading indicator and reset button
        this.classList.remove("loading");
        indicatorLabel.textContent = originalText;
        this.disabled = false;
      }, 1500); // Simulated delay of 1.5 seconds
    });
  });

  // Sidebar and Theme Toggle Functionality
  const sidebar = document.getElementById("sidebar");
  const sidebarToggle = document.getElementById("sidebarToggle");
  const body = document.body;
  const toggleModeBtn = document.getElementById("toggleMode");
  const html = document.documentElement;

  // Sidebar Toggle
  if (sidebarToggle && sidebar) {
    sidebarToggle.addEventListener("click", function() {
      sidebar.classList.toggle("collapsed");
      body.classList.toggle("sidebar-collapsed");
      
      // Update icon
      const icon = sidebarToggle.querySelector("i");
      if (sidebar.classList.contains("collapsed")) {
        icon.classList.replace("bi-chevron-left", "bi-chevron-right");
      } else {
        icon.classList.replace("bi-chevron-right", "bi-chevron-left");
      }
      
      // Store state
      localStorage.setItem("sidebar-collapsed", sidebar.classList.contains("collapsed"));
    });

    // Restore sidebar state
    if (localStorage.getItem("sidebar-collapsed") === "true") {
      sidebar.classList.add("collapsed");
      body.classList.add("sidebar-collapsed");
      const icon = sidebarToggle.querySelector("i");
      if (icon) icon.classList.replace("bi-chevron-left", "bi-chevron-right");
    }
  }

  // Theme Toggle
  if (toggleModeBtn) {
    toggleModeBtn.addEventListener("click", function() {
      const currentTheme = html.getAttribute("data-theme") || "light";
      const newTheme = currentTheme === "light" ? "dark" : "light";
      
      html.setAttribute("data-theme", newTheme);
      localStorage.setItem("theme", newTheme);
      
      // Update icons
      const lightIcon = toggleModeBtn.querySelector(".light-icon");
      const darkIcon = toggleModeBtn.querySelector(".dark-icon");
      
      if (newTheme === "dark") {
        lightIcon.classList.add("d-none");
        darkIcon.classList.remove("d-none");
      } else {
        lightIcon.classList.remove("d-none");
        darkIcon.classList.add("d-none");
      }
      
      // Dispatch event for components that need to know about theme change (like ECharts)
      window.dispatchEvent(new CustomEvent("themeChanged", { detail: { theme: newTheme } }));
    });

    // Restore theme
    const savedTheme = localStorage.getItem("theme");
    if (savedTheme) {
      html.setAttribute("data-theme", savedTheme);
      const lightIcon = toggleModeBtn.querySelector(".light-icon");
      const darkIcon = toggleModeBtn.querySelector(".dark-icon");
      if (savedTheme === "dark") {
        lightIcon?.classList.add("d-none");
        darkIcon?.classList.remove("d-none");
      }
    }
  }

  function searchListUpdate(customMenus) {
    customMenus.forEach((item) => {
      const li = document.createElement("li");
      if (item.separator) {
        li.innerHTML = `
                    <p class="suggestion-title mb-0">${item.separator}</p>
                `;
      } else {
        li.innerHTML = `
                        <a href="${item.link}" class="text-body">
                            <div class="d-flex align-items-center gap-2">
                                <i class="${item.icon}"></i>
                                ${item.name}
                            </div>
                        </a>
                    `;
      }
      if (item.separator) li.classList.add("mt-3", "mb-1");
      else li.classList.add("suggestion-item", "d-flex", "align-items-center");

      searchList.appendChild(li);
    });

    if (customMenus.length === 0) {
      const li = document.createElement("li");
      li.innerHTML = `
                <div class="d-flex align-items-center flex-column justify-content-center gap-2 my-16">
                    <i class="ri-file-info-line fs-1 text-muted"></i>
                    <p class="suggestion-title mb-0 text-center">No results found</p>
                </div>
            `;
      li.classList.add("mt-3", "mb-1");
      searchList.appendChild(li);
    }
  }
  // Initialize search input functionality
  const searchInputInModal = document.getElementById("searchInputInModal");
  const searchList = document.getElementById("searchList");
  if (searchInputInModal) {
    const allMenus = document.querySelectorAll(
      "#sidebar-simplebar ul.pe-main-menu.list-unstyled"
    );
    const customMenus = [];
    allMenus.forEach((menu) => {
      const items = menu.querySelectorAll("li");
      items.forEach((item) => {
        if (item.querySelector("a") === null) return;
        else if (item.querySelector("a").getAttribute("href").includes("#")) {
          customMenus.push({
            separator: item.querySelector("a").textContent,
            name: "",
          });
        } else {
          customMenus.push({
            name: item.querySelector("a").textContent,
            icon:
              item.querySelector("i")?.className ??
              "ri-circle-line pe-nav-icon fs-10",
            link: item.querySelector("a").getAttribute("href"),
          });
        }
      });
    });

    searchListUpdate(customMenus);

    searchInputInModal.addEventListener("input", function () {
      const searchText = this.value.toLowerCase();
      searchList.innerHTML = ""; // Clear previous results
      searchListUpdate(
        customMenus.filter((item) =>
          item.name.toLowerCase().includes(searchText)
        )
      );
    });
  }
  const horizontalMenus = document.getElementById("horizontal-menu");
  if (horizontalMenus) {
    const horizontalMenuItems =
      horizontalMenus.querySelectorAll("nav > ul > li > a");
    horizontalMenuItems.forEach((item) => {
      item.addEventListener("click", (e) => {
        e.preventDefault();
        setTimeout(() => {
          item.setAttribute("aria-expanded", "false");
          item.classList.remove("collapsed");
          item.nextElementSibling.classList.remove("show");
          // console.log(item.nextElementSibling, item);
        }, 300);
      });
    });
  }
}

// Call the function to initialize features
document.addEventListener("DOMContentLoaded", initializeAppFeatures);
