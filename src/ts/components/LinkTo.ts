class LinkTo extends HTMLAnchorElement {
  static observedAttributes = ['href', 'dataMethod'];
  href: string = '';
  dataMethod: string = '';
  reloadId: string = '';
  resourceId: string = '';
  constructor() {
    super();
  }

  async makeRequest() {
    const csrfToken = (document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement)?.content;
    const headers: HeadersInit = {
      'X-CSRF-Token': csrfToken || '',
    };

    const response = await fetch(this.href, {
      method: this.dataMethod,
      headers: headers,
    });

    switch (this.dataMethod) {
      case 'POST':
        if (response.ok) {
          window.location.href = response.url;
        }
        break;
      case 'PUT':
        if (response.ok) {
          window.location.href = response.url;
        }
        break;
      case 'DELETE':
        // Manually follow the redirect if the server indicated one.
        if (response.redirected) {
          window.location.href = response.url;
        }
        break;
      case 'GET':
        if (response.ok) {
          const reloadElement = document.querySelector(`#${this.reloadId}`);
          if (reloadElement) {
            reloadElement.innerHTML = await response.text();
            // window.location.hash = `#${this.resourceId}`;
            history.pushState({ id: this.resourceId }, "", `/purchases/${this.resourceId}`);
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
    this.addEventListener('click', async (event) => {
      this.dataMethod = this.getAttribute('dataMethod') || '';
      this.dataMethod = this.getAttribute('dataMethod') || '';
      this.reloadId = this.getAttribute('reloadId') || '';
      this.href = this.getAttribute('href') || '';
      this.resourceId = this.getAttribute('resourceId') || '';

      event.preventDefault();
      await this.makeRequest();
    });
  }
}

customElements.define("link-to", LinkTo, { extends: 'a' });
