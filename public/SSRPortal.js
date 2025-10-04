// components/SSRPortal.ts
class SSRPortal extends HTMLElement {
  static observedAttributes = ["href"];
  href;
  constructor(newUrl) {
    super();
    this.href = newUrl;
  }
  async connectedCallback() {
    this.href = this.getAttribute("href") || "";
    const form = await fetch(this.href);
    if (form.ok) {
      const html = await form.text();
      this.innerHTML = html;
    }
  }
}
customElements.define("ssr-portal", SSRPortal);
