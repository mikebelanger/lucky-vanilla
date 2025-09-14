// components/AnotherComponent.ts
class AnotherClass extends HTMLElement {
  constructor() {
    super();
    console.log("Hello from AnotherClass");
  }
  connectedCallback() {
    console.log("test from yet another class");
    fetch("/some_other_page").then((r) => {
      return r.text();
    }).then((text) => {
      this.innerHTML = text;
    });
  }
}
customElements.define("another-component", AnotherClass);
