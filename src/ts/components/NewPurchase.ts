class NewPurchase extends HTMLElement {
  constructor() {
    super();
  }
  async connectedCallback() {
    const form = await fetch('/purchases/new');
    if (form.ok) {
      const html = await form.text();
      this.innerHTML = html;
    }
  }
}

customElements.define('new-purchase', NewPurchase);
