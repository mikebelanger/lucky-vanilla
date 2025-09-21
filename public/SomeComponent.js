// components/SomeComponent.ts
class SomeClass extends HTMLElement {
  constructor() {
    super();
  }
  loadPage() {
    fetch("/some_page").then((r) => {
      return r.text();
    }).then((text) => {
      this.innerHTML = text;
    }).then(() => {
      window.location.href += "#table";
    });
  }
  addButton() {
    const button = document.createElement("button");
    button.textContent = "Load Page";
    button.addEventListener("click", (evt) => {
      this.loadPage();
    });
    this.appendChild(button);
  }
  connectedCallback() {
    console.log("test with update2");
    this.addButton();
  }
}
customElements.define("some-component", SomeClass);
