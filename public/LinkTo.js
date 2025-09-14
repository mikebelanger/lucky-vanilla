// components/LinkTo.ts
class LinkTo extends HTMLAnchorElement {
  static observedAttributes = ["href", "dataMethod"];
  href;
  dataMethod;
  constructor() {
    super();
    this.href = this.getAttribute("href") || "";
    this.dataMethod = this.getAttribute("dataMethod") || "";
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
    if (response.redirected) {
      window.location.href = response.url;
    }
  }
  connectedCallback() {
    this.addEventListener("click", async (event) => {
      event.preventDefault();
      await this.makeRequest();
    });
  }
}
customElements.define("link-to", LinkTo, { extends: "a" });
