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

// Translations will be loaded from the backend
let translations = {};

function applyTranslations() {
  // Update HTML lang attribute
  const htmlRoot = document.getElementById("html-root");
  if (htmlRoot && translations.html_lang) {
    htmlRoot.setAttribute("lang", translations.html_lang);
  }

  // Update elements with data-i18n-text attribute
  document.querySelectorAll("[data-i18n-text]").forEach((el) => {
    const key = el.getAttribute("data-i18n-text");
    if (translations[key]) {
      el.textContent = translations[key];
    }
  });

  // Update textarea placeholder
  document.querySelectorAll("[data-i18n-placeholder]").forEach((el) => {
    const key = el.getAttribute("data-i18n-placeholder");
    if (translations[key]) {
      el.setAttribute("placeholder", translations[key]);
    }
  });

  // Update counter with current count
  updateCounter();
}

function updateCounter() {
  const length = textarea.value.length;
  const counterFormat = translations.counter_format || "{count} / {max}";
  counter.textContent = counterFormat
    .replace("{count}", length)
    .replace("{max}", MAX_CHARS);
  submitBtn.disabled = length === 0 || length > MAX_CHARS;
}

function showForm() {
  formView.classList.remove("hidden");
  listView.classList.add("hidden");
  textarea.focus();
  setTimeout(() => textarea.focus(), 50);
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
      const confirmMessage = translations.delete_confirm || "Delete this idea?";
      const ok = window.confirm(confirmMessage);
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
    span.textContent = translations.delete_label || "delete";

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
    formError.textContent = translations.form_error || "Unable to save this idea.";
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

window.addEventListener("pywebviewready", async () => {
  // Load translations from backend
  try {
    translations = await window.pywebview.api.get_translations();
    applyTranslations();
  } catch (error) {
    console.error("Failed to load translations:", error);
    // Use default English translations as fallback
    translations = {
      textarea_placeholder: "Your idea:",
      counter_format: "{count} / {max}",
      submit_button: "Save this idea",
      show_list_button: "Ideas list",
      form_error: "Unable to save this idea.",
      list_title: "Ideas",
      new_idea_button: "I have a new idea",
      empty_state: "No ideas yet.",
      delete_label: "delete",
      delete_confirm: "Delete this idea?",
      html_lang: "en",
    };
    applyTranslations();
  }
  
  updateCounter();
  showForm();
});
