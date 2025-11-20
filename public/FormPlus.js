// components/FormPlus.ts
class FormPlus extends HTMLFormElement {
  constructor() {
    super();
  }
  connectedCallback() {
    this.addEventListener("submit", this.handleSubmit);
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
      }).then((response) => response.json()).then((data) => console.log(data)).catch((error) => console.error(error));
    }
  }
}
customElements.define("form-plus", FormPlus, { extends: "form" });
