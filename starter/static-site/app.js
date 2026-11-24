const button = document.querySelector("#try-button");
const message = document.querySelector("#message");
button?.addEventListener("click", () => {
  message.textContent = "Great start. Now change this page into your own idea.";
});
