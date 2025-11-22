// components/FormPlus.ts
class FormPlus extends HTMLFormElement {
  static observedAttributes = ["replace-id"];
  constructor() {
    super();
    this.replaceId = this.getAttribute("replace-id");
  }
  connectedCallback() {
    this.addEventListener("submit", this.handleSubmit);
    this.replaceId = this.getAttribute("replace-id");
  }
  handleSubmit(event) {
    event.preventDefault();
    const formData = new FormData(this);
    const url = this.getAttribute("action");
    const method = this.getAttribute("method");
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
    const headers = {
      "X-CSRF-Token": csrfToken || "",
      "Content-Type": "application/json"
    };
    const formObject = Object.fromEntries(formData);
    const body = JSON.stringify({
      split: {
        paid_on: formObject.paid_on,
        split_id: parseInt(formObject.split)
      }
    });
    if (url && method) {
      fetch(url, {
        method,
        body,
        headers
      }).then((response) => {
        const html = response.text();
        return html;
      }).then((html) => {
        const replaceTarget = document.getElementById(this.replaceId);
        if (replaceTarget) {
          replaceTarget.innerHTML = html;
        }
      }).catch((error) => console.error(error));
    }
  }
}
customElements.define("form-plus", FormPlus, { extends: "form" });
