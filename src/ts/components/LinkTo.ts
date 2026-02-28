class LinkTo extends HTMLAnchorElement {
  static observedAttributes = ['href', 'data-method', 'data-confirm-message'];
  href: string = '';
  dataMethod: string = '';
  reloadId: string = '';
  resourceId: string = '';
  confirm: string = '';
  dataConfirmMessage: string = '';
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

          if (this.reloadId) {
            const toReplace = document.getElementById(this.reloadId);
            if (toReplace) {
              // toReplace.innerHTML = response.body
            }
          }
        }
        break;
      case 'DELETE':
        // Manually follow the redirect if the server indicated one.
        if (response.redirected) {
          window.location.href = response.url;
        } else {
          if (this.reloadId) {
            const toRemove = document.getElementById(this.reloadId);
            if (toRemove) {
              toRemove.innerHTML = '';
            }
          }
        }
        break;
      case 'GET':
        if (response.ok) {
          if (this.reloadId) {
            const reloadElement = document.querySelector(`#${this.reloadId}`);
            if (reloadElement) {
              reloadElement.innerHTML = await response.text();
              // window.location.hash = `#${this.resourceId}`;
              // history.pushState({ id: this.resourceId }, "", `/purchases/${this.resourceId}`);
            }
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
      this.dataMethod = this.getAttribute('data-method') || '';
      this.reloadId = this.getAttribute('reload-id') || '';
      this.href = this.getAttribute('href') || '';
      this.resourceId = this.getAttribute('resource-id') || '';
      this.dataConfirmMessage = this.getAttribute('data-confirm-message') || '';

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

customElements.define("link-to", LinkTo, { extends: 'a' });
