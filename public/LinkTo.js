// components/LinkTo.ts
class LinkTo extends HTMLAnchorElement {
  static observedAttributes = ["href", "data-method", "data-confirm-message"];
  href = "";
  dataMethod = "";
  reloadId = "";
  resourceId = "";
  confirm = "";
  dataConfirmMessage = "";
  constructor() {
    super();
  }
  async makeRequest() {
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
    const headers = {
      "X-CSRF-Token": csrfToken || ""
    };
    const response = await fetch(this.href, {
      method: this.dataMethod,
      headers
    });
    switch (this.dataMethod) {
      case "POST":
        if (response.ok) {
          window.location.href = response.url;
        }
        break;
      case "PUT":
        if (response.ok) {
          window.location.href = response.url;
        }
        break;
      case "DELETE":
        if (response.redirected) {
          window.location.href = response.url;
        }
        break;
      case "GET":
        if (response.ok) {
          const reloadElement = document.querySelector(`#${this.reloadId}`);
          if (reloadElement) {
            reloadElement.innerHTML = await response.text();
          }
        }
        break;
      default:
        if (response.ok) {
          window.location.href = response.url;
        }
        break;
    }
  }
  connectedCallback() {
    this.addEventListener("click", async (event) => {
      this.dataMethod = this.getAttribute("data-method") || "";
      this.reloadId = this.getAttribute("reload-id") || "";
      this.href = this.getAttribute("href") || "";
      this.resourceId = this.getAttribute("resource-id") || "";
      this.dataConfirmMessage = this.getAttribute("data-confirm-message") || "";
      event.preventDefault();
      if (this.dataConfirmMessage.length > 0) {
        const confirmed = confirm(this.dataConfirmMessage);
        if (confirmed) {
          await this.makeRequest();
        }
      } else {
        await this.makeRequest();
      }
    });
  }
}
customElements.define("link-to", LinkTo, { extends: "a" });
