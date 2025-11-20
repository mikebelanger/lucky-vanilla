class FormPlus extends HTMLFormElement {
  constructor() {
    super();
  }

  connectedCallback() {
    this.addEventListener('submit', this.handleSubmit);
  }

  handleSubmit(event: Event) {
    event.preventDefault();
    const formData = new FormData(this);

    const url = this.getAttribute('action');
    const method = this.getAttribute('method');

    const csrfToken = (document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement)?.content;
    const headers: HeadersInit = {
      'X-CSRF-Token': csrfToken || '',
      'Content-Type': 'application/json'
    };
    // TODO - figure out the proper type
    const formObject = Object.fromEntries(formData as any);
    const body = JSON.stringify({
      split: {
        paid_on: formObject.paid_on,
        split_id: parseInt(formObject.split)
      }
    });

    if (url && method) {
      fetch(url, {
        method: method,
        body,
        headers
      })
        .then(response => response.json())
        .then(data => console.log(data))
        .catch(error => console.error(error));
    }
  }
}

customElements.define('form-plus', FormPlus, { extends: 'form' });
