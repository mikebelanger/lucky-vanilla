class SplitRowForm extends HTMLFormElement {
  static observedAttributes = ['replace-id'];
  constructor() {
    super();
    this.replaceId = this.getAttribute('replace-id');
  }

  connectedCallback() {
    this.addEventListener('submit', this.handleSubmit);
    this.replaceId = this.getAttribute('replace-id');
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
        method,
        body,
        headers
      })
        .then(response => {
          const html = response.text();
          return html;
        })
        .then(html => {
          const replaceTarget = document.getElementById(this.replaceId);
          if (replaceTarget) {
            replaceTarget.innerHTML = html;
          }
        })
        .catch(error => console.error(error));
    }
  }
}

customElements.define('split-row-form', SplitRowForm, { extends: 'form' });
