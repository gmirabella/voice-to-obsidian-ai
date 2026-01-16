# Homepage

```dataviewjs
// ============ GLOBAL TERMINAL STYLE ============
const rootEl = dv.container;
rootEl.style.fontFamily = "'JetBrains Mono', 'Fira Code', 'SF Mono', 'Consolas', monospace";

// ============ CONFIG ============
const habitEmojis = ["🥊", "🧘", "🚶", "✨"];
function isHabit(task) {
  return habitEmojis.some(emoji => task.text.includes(emoji));
}

const folderLabels = {
  "Work": { text: "Lavoro", color: "#3498db", emoji: "💼" },
  "Health": { text: "Salute", color: "#e74c3c", emoji: "🏃" }
};

// ============ HEADER ============
const header = dv.el("div", "");
header.style.cssText = `
  display: flex; justify-content: space-between; align-items: center;
  margin-bottom: 20px; padding-bottom: 16px;
  border-bottom: 1px solid var(--background-modifier-border);
`;

const greeting = header.createDiv();
const hour = new Date().getHours();
const greetText = hour < 12 ? "Buongiorno" : hour < 17 ? "Buon pomeriggio" : "Buonasera";
greeting.createEl("h2", {text: `> ${greetText}, Graziana_`}).style.cssText = "margin: 0; letter-spacing: -0.5px;";

const dateDiv = header.createDiv();
const today = new Date();
const options = { weekday: 'long', month: 'long', day: 'numeric', year: 'numeric' };
dateDiv.textContent = today.toLocaleDateString('it-IT', options);
dateDiv.style.cssText = "font-size: 0.9em; opacity: 0.7;";

// ============ STATS ROW ============
const statsRow = dv.el("div", "");
statsRow.style.cssText = `
  display: flex; gap: 12px; margin-bottom: 20px; flex-wrap: wrap;
`;

const allTasks = dv.pages().file.tasks;
const completedThisWeek = allTasks.where(t => t.completed && !isHabit(t)).length;
const openTasks = allTasks.where(t => !t.completed && !isHabit(t)).length;

const dailyNotes = dv.pages('"Daily Journal"')
  .where(p => p.file.name.match(/^\d{4}-\d{2}-\d{2}$/))
  .sort(p => p.file.name, 'desc')
  .limit(7);

let habitsDoneToday = 0;
let habitsTotal = 4;
const todayStr = dv.date("today").toFormat("yyyy-MM-dd");
for (const note of dailyNotes) {
  if (note.file.name === todayStr) {
    const habits = note.file.tasks.where(t => isHabit(t));
    habitsDoneToday = habits.where(t => t.completed).length;
    habitsTotal = habits.length || 4;
    break;
  }
}

function createStatCard(emoji, label, value, subtext, color) {
  const card = statsRow.createDiv();
  card.style.cssText = `
    background: var(--background-secondary);
    padding: 14px 18px; border-radius: 4px;
    min-width: 140px; border-left: 3px solid ${color};
    border: 1px solid var(--background-modifier-border);
  `;
  card.createDiv({text: `${emoji} ${label}`}).style.cssText = "font-size: 0.75em; opacity: 0.7; margin-bottom: 4px; text-transform: uppercase; letter-spacing: 1px;";
  card.createDiv({text: value}).style.cssText = `font-size: 1.4em; font-weight: bold; color: ${color};`;
  if (subtext) card.createDiv({text: subtext}).style.cssText = "font-size: 0.7em; opacity: 0.5;";
}

createStatCard("✅", "Completati", completedThisWeek.toString(), "questa settimana", "#27ae60");
createStatCard("📋", "Task Aperti", openTasks.toString(), "rimanenti", "#3498db");
createStatCard("🏃", "Habits", `${habitsDoneToday}/${habitsTotal}`, "oggi", habitsDoneToday >= habitsTotal ? "#27ae60" : "#f39c12");

// ============ QUICK ADD ============
const quickSection = dv.el("div", "");
quickSection.style.cssText = `
  background: var(--background-secondary);
  padding: 12px 16px; border-radius: 4px;
  margin-bottom: 20px; display: flex; gap: 8px; align-items: center;
  border: 1px solid var(--background-modifier-border);
`;
quickSection.createSpan({text: ">"}).style.cssText = "color: #27ae60; font-weight: bold;";
const quickNote = quickSection.createSpan({text: "apri_nota_oggi per aggiungere task e pensieri"});
quickNote.style.cssText = "flex: 1; font-size: 0.85em; opacity: 0.7;";
const todayLink = quickSection.createEl("a", {text: "[APRI]"});
todayLink.style.cssText = "font-size: 0.85em; cursor: pointer; color: #3498db;";
todayLink.onclick = () => app.workspace.openLinkText(`Daily Journal/${todayStr}`, "", false);

// ============ TASKS KANBAN ============
const kanbanTitle = dv.el("h3", "$ tasks --list");
kanbanTitle.style.cssText = "margin: 0 0 12px 0; color: #f39c12;";

const dvToday = dv.date("today");
const jsToday = new Date();
const dayOfWeek = jsToday.getDay();
const thisWeekEnd = dvToday.plus({days: 6 - dayOfWeek});
const nextWeekEnd = thisWeekEnd.plus({days: 7});

const tasks = dv.pages().file.tasks.where(t => !t.completed && !isHabit(t));

const todayTasks = tasks.filter(t => {
  if (!t.due) return false;
  return t.due.ts <= dvToday.ts || t.text.includes("🔁");
});

const thisWeekTasks = tasks.filter(t => {
  if (!t.due) return false;
  return t.due.ts > dvToday.ts && t.due.ts <= thisWeekEnd.ts;
});

const nextWeekTasks = tasks.filter(t => {
  if (!t.due) return false;
  return t.due.ts > thisWeekEnd.ts && t.due.ts <= nextWeekEnd.ts;
});

const laterTasks = tasks.filter(t => {
  if (!t.due) return false;
  return t.due.ts > nextWeekEnd.ts;
});

const noDueTasks = tasks.filter(t => !t.due);

const kanban = dv.el("div", "");
kanban.style.cssText = `
  display: flex; gap: 12px; margin-bottom: 24px;
  overflow-x: auto; padding-bottom: 8px;
`;

function getLabel(task) {
  for (const [folder, info] of Object.entries(folderLabels)) {
    if (task.path.includes(folder)) return info;
  }
  return null;
}

async function completeTask(task) {
  const file = app.vault.getAbstractFileByPath(task.path);
  if (!file) return;
  const content = await app.vault.read(file);
  const lines = content.split("\n");
  if (lines[task.line]) {
    const todayDate = new Date().toISOString().split('T')[0];
    lines[task.line] = lines[task.line].replace("- [ ]", "- [x]").replace(/$/, ` ✅ ${todayDate}`);
    await app.vault.modify(file, lines.join("\n"));
  }
}

function renderColumn(container, title, color, taskList) {
  const col = container.createDiv();
  col.style.cssText = `
    flex: 1; min-width: 200px; max-width: 280px;
    background: var(--background-secondary);
    border-radius: 4px; padding: 12px;
    border: 1px solid var(--background-modifier-border);
    border-top: 3px solid ${color};
  `;

  const colHeader = col.createDiv();
  colHeader.style.cssText = "display: flex; justify-content: space-between; margin-bottom: 10px;";
  colHeader.createEl("h4", {text: title}).style.cssText = "margin: 0; font-size: 0.8em; text-transform: uppercase; letter-spacing: 1px;";
  colHeader.createSpan({text: `[${taskList.length}]`}).style.cssText = `color: ${color}; font-size: 0.8em;`;

  const list = col.createDiv();
  list.style.cssText = "max-height: 35vh; overflow-y: auto;";

  if (taskList.length === 0) {
    const empty = list.createDiv({text: "-- vuoto --"});
    empty.style.cssText = "color: var(--text-muted); font-size: 0.8em; padding: 8px; text-align: center; opacity: 0.5;";
  } else {
    for (const task of taskList) {
      const item = list.createDiv();
      item.style.cssText = `
        background: var(--background-primary);
        padding: 8px 10px; margin-bottom: 6px;
        border-radius: 3px; font-size: 0.8em;
        border-left: 2px solid ${color};
      `;

      const topRow = item.createDiv();
      topRow.style.cssText = "display: flex; align-items: flex-start; gap: 8px;";

      const checkbox = topRow.createEl("input", {type: "checkbox"});
      checkbox.style.cssText = "margin-top: 2px; cursor: pointer;";
      checkbox.onclick = async (e) => {
        e.preventDefault();
        item.style.opacity = "0.5";
        item.style.textDecoration = "line-through";
        await completeTask(task);
      };

      const text = task.text
        .replace(/[📅🛫⏫🔼🔽🔁✅]\s*\d{4}-\d{2}-\d{2}/g, "")
        .replace(/[📅🛫⏫🔼🔽🔁]/g, "").trim();
      topRow.createSpan({text}).style.cssText = "flex: 1;";

      if (task.link) {
        const link = topRow.createEl("a", {text: "→"});
        link.style.cssText = "font-size: 0.75em; opacity: 0.5; cursor: pointer;";
        link.onclick = (e) => { e.preventDefault(); app.workspace.openLinkText(task.link.path, "", false); };
      }

      const label = getLabel(task);
      if (label) {
        const labelSpan = item.createSpan({text: `[${label.text}]`});
        labelSpan.style.cssText = `
          display: inline-block; margin-top: 6px; margin-left: 22px;
          font-size: 0.65em; color: ${label.color};
        `;
      }
    }
  }
}

renderColumn(kanban, "Oggi", "#e74c3c", todayTasks.array());
renderColumn(kanban, "Questa Sett.", "#f39c12", thisWeekTasks.array());
renderColumn(kanban, "Prossima Sett.", "#3498db", nextWeekTasks.array());
renderColumn(kanban, "Dopo", "#9b59b6", laterTasks.array());
renderColumn(kanban, "No Data", "#95a5a6", noDueTasks.array());

// ============ MEETINGS ============
const meetingsTitle = dv.el("h3", "$ calendar --today");
meetingsTitle.style.cssText = "margin: 0 0 12px 0; color: #9b59b6;";

const meetingsContainer = dv.el("div", "");
meetingsContainer.style.cssText = `
  background: var(--background-secondary);
  padding: 16px; border-radius: 4px; margin-bottom: 24px;
  border: 1px solid var(--background-modifier-border);
`;

// Leggi eventi da file se esiste, altrimenti mostra istruzioni
const calFile = dv.page("Meetings Today");
if (calFile) {
  const content = await dv.io.load(calFile.file.path);
  const lines = content.split("\n").filter(l => l.startsWith("- "));
  if (lines.length === 0) {
    meetingsContainer.createDiv({text: "-- nessun meeting oggi --"}).style.cssText = "opacity: 0.5; font-size: 0.85em;";
  } else {
    for (const line of lines) {
      const eventDiv = meetingsContainer.createDiv();
      eventDiv.style.cssText = "padding: 8px 0; font-size: 0.85em; border-bottom: 1px solid var(--background-modifier-border);";
      eventDiv.textContent = line.substring(2);
    }
  }
} else {
  const infoDiv = meetingsContainer.createDiv();
  infoDiv.innerHTML = `<span style="opacity: 0.6;">Chiedi a Claude:</span> <span style="color: #27ae60;">"aggiorna meetings"</span>`;
  infoDiv.style.cssText = "font-size: 0.85em;";
}

// ============ HABITS STREAK ============
const habitsTitle = dv.el("h3", "$ habits --week");
habitsTitle.style.cssText = "margin: 0 0 12px 0; color: #27ae60;";

const habits = [
  {name: "Yoga + Meditazione", emoji: "🧘"},
  {name: "Passeggiata con Lev", emoji: "🚶"},
  {name: "Muay Thai", emoji: "🥊"},
  {name: "Skincare", emoji: "✨"}
];

const habitsContainer = dv.el("div", "");
habitsContainer.style.cssText = `
  background: var(--background-secondary);
  padding: 16px; border-radius: 4px; margin-bottom: 24px;
  border: 1px solid var(--background-modifier-border);
`;

for (const habit of habits) {
  const row = habitsContainer.createDiv();
  row.style.cssText = "display: flex; align-items: center; gap: 12px; margin-bottom: 8px;";

  const label = row.createSpan({text: `${habit.emoji} ${habit.name}`});
  label.style.cssText = "width: 200px; font-size: 0.8em;";

  const dots = row.createDiv();
  dots.style.cssText = "display: flex; gap: 4px;";

  const notesReversed = [...dailyNotes].reverse();
  for (const note of notesReversed) {
    const dot = dots.createDiv();
    dot.style.cssText = `
      width: 24px; height: 24px; border-radius: 3px;
      display: flex; align-items: center; justify-content: center;
      font-size: 0.7em; border: 1px solid var(--background-modifier-border);
    `;

    const noteTasks = note.file.tasks.where(t => t.text.includes(habit.name));
    if (noteTasks.length === 0) {
      dot.style.background = "var(--background-primary)";
      dot.textContent = "-";
      dot.style.opacity = "0.3";
    } else if (noteTasks[0].completed) {
      dot.style.background = "#27ae60";
      dot.textContent = "✓";
      dot.style.color = "white";
    } else {
      dot.style.background = "#e74c3c";
      dot.textContent = "✗";
      dot.style.color = "white";
    }
    dot.title = note.file.name;
  }
}

// ============ RECENT NOTES ============
const recentTitle = dv.el("h3", "$ notes --recent");
recentTitle.style.cssText = "margin: 0 0 12px 0; color: #3498db;";

const recentNotes = dv.pages()
  .where(p => !p.file.path.includes(".obsidian") && !p.file.name.match(/^\d{4}-\d{2}-\d{2}$/) && p.file.name !== "Homepage" && p.file.name !== "CLAUDE")
  .sort(p => p.file.mtime, 'desc')
  .limit(5);

const recentContainer = dv.el("div", "");
recentContainer.style.cssText = `
  background: var(--background-secondary);
  border-radius: 4px; overflow: hidden; margin-bottom: 24px;
  border: 1px solid var(--background-modifier-border);
`;

for (const note of recentNotes) {
  const row = recentContainer.createDiv();
  row.style.cssText = `
    padding: 10px 14px; cursor: pointer;
    border-bottom: 1px solid var(--background-modifier-border);
    display: flex; justify-content: space-between; align-items: center;
  `;
  row.onmouseenter = () => row.style.background = "var(--background-primary)";
  row.onmouseleave = () => row.style.background = "transparent";
  row.onclick = () => app.workspace.openLinkText(note.file.path, "", false);

  row.createSpan({text: `> ${note.file.name}`}).style.cssText = "font-size: 0.85em;";

  const folder = note.file.folder || "root";
  const folderSpan = row.createSpan({text: `[${folder}]`});
  folderSpan.style.cssText = "font-size: 0.7em; opacity: 0.5;";
}

// ============ FOLDER SHORTCUTS (in fondo) ============
const foldersTitle = dv.el("h3", "$ cd /");
foldersTitle.style.cssText = "margin: 0 0 12px 0; color: #95a5a6;";

const shortcutsSection = dv.el("div", "");
shortcutsSection.style.cssText = `
  display: flex; gap: 12px; flex-wrap: wrap;
`;

for (const [folder, info] of Object.entries(folderLabels)) {
  const card = shortcutsSection.createDiv();
  card.style.cssText = `
    background: var(--background-secondary);
    padding: 16px 24px; border-radius: 4px;
    cursor: pointer; transition: transform 0.1s;
    border: 1px solid var(--background-modifier-border);
    border-left: 3px solid ${info.color};
    min-width: 120px; text-align: center;
  `;
  card.onmouseenter = () => card.style.transform = "translateY(-2px)";
  card.onmouseleave = () => card.style.transform = "translateY(0)";
  card.onclick = () => app.workspace.openLinkText(folder, "", false);

  card.createDiv({text: info.emoji}).style.cssText = "font-size: 1.3em; margin-bottom: 6px;";
  card.createDiv({text: info.text}).style.cssText = "font-size: 0.85em;";
}
```
