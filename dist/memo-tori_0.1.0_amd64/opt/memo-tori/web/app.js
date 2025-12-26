const MAX_CHARS = 5000;
const PREVIEW_CHARS = 300;

const formView = document.getElementById("form-view");
const listView = document.getElementById("list-view");
const textarea = document.getElementById("idea");
const counter = document.getElementById("counter");
const submitBtn = document.getElementById("submit");
const showListBtn = document.getElementById("show-list");
const showFormBtn = document.getElementById("show-form");
const ideasContainer = document.getElementById("ideas");
const emptyState = document.getElementById("empty-state");
const formError = document.getElementById("form-error");

function updateCounter() {
  const length = textarea.value.length;
  counter.textContent = `${length} / ${MAX_CHARS}`;
  submitBtn.disabled = length === 0 || length > MAX_CHARS;
}

function showForm() {
  formView.classList.remove("hidden");
  listView.classList.add("hidden");
}

function showList() {
  formView.classList.add("hidden");
  listView.classList.remove("hidden");
}

function truncate(text) {
  if (text.length <= PREVIEW_CHARS) {
    return text;
  }
  return `${text.slice(0, PREVIEW_CHARS)}...`;
}

function renderIdeas(ideas) {
  ideasContainer.innerHTML = "";
  if (!ideas.length) {
    emptyState.classList.remove("hidden");
    return;
  }
  emptyState.classList.add("hidden");

  ideas.forEach((idea, index) => {
    const card = document.createElement("div");
    card.className = "idea-card";

    const text = document.createElement("p");
    text.textContent = truncate(idea);

    const label = document.createElement("label");
    const checkbox = document.createElement("input");
    checkbox.type = "checkbox";
    checkbox.addEventListener("change", async () => {
      if (!checkbox.checked) {
        return;
      }
      const ok = window.confirm("Effacer cette idee ?");
      if (!ok) {
        checkbox.checked = false;
        return;
      }
      const result = await window.pywebview.api.delete_idea(index);
      if (result.ok) {
        await refreshList();
      } else {
        checkbox.checked = false;
      }
    });
    const span = document.createElement("span");
    span.textContent = "effacer";

    label.appendChild(checkbox);
    label.appendChild(span);

    card.appendChild(text);
    card.appendChild(label);
    ideasContainer.appendChild(card);
  });
}

async function refreshList() {
  const ideas = await window.pywebview.api.list_ideas();
  renderIdeas(ideas);
}

async function submitIdea() {
  formError.textContent = "";
  const text = textarea.value;
  const result = await window.pywebview.api.save_idea(text);
  if (!result.ok) {
    formError.textContent = "Impossible d'enregistrer cette idee.";
    return;
  }
  textarea.value = "";
  updateCounter();
}

textarea.addEventListener("input", updateCounter);
submitBtn.addEventListener("click", submitIdea);
showListBtn.addEventListener("click", async () => {
  showList();
  await refreshList();
});
showFormBtn.addEventListener("click", showForm);

window.addEventListener("pywebviewready", () => {
  updateCounter();
  showForm();
});
