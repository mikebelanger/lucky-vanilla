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
    fetch(this.href, { method: this.dataMethod });
  }
  connectedCallback() {
    this.addEventListener("click", async (event) => {
      event.preventDefault();
      await this.makeRequest();
    });
  }
}
customElements.define("link-to", LinkTo, { extends: "a" });
