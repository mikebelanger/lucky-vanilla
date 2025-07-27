"use strict";
class SomeClass extends HTMLElement {
  constructor() {
    super();
    console.log("Hello from SomeClass");
  }
  connectedCallback() {
    fetch("/some_page")
      .then((r) => {
        return r.text();
      })
      .then((text) => {
        this.innerHTML = text;
      });
  }
}
customElements.define("some-component", SomeClass);
