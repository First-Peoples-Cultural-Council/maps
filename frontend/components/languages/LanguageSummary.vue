<template>
  <div>
    <div class="ls">
      <div>
        <h5>Population</h5>
        {{ population }}
      </div>
      <div>
        <h5>Fluent Speakers</h5>
        {{ speakers }}
      </div>
    </div>
    <div class="ls mt-2">
      <div>
        <h5>Understanding or speak somewhat</h5>
        {{ somewhat }}
      </div>
      <div>
        <h5>Learning Speakers</h5>
        {{ learners }}
      </div>
    </div>
    <!--
    <table class="languageSummary">
      <thead>
        <tr>
          <th class="text-uppercase">Population</th>
          <th class="text-uppercase">Fluent Speakers</th>
          <th class="text-uppercase">Understanding or speak somewhat</th>
          <th class="text-uppercase">Learning Speakers</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>{{ population }}</td>
          <td>{{ speakers }}</td>
          <td>{{ somewhat }}</td>
          <td>{{ learners }}</td>
        </tr>
      </tbody>
    </table>
    -->
  </div>
</template>

<script>
export default {
  props: {
    population: {
      type: String,
      default: ''
    },
    speakers: {
      type: String,
      default: ''
    },
    somewhat: {
      type: String,
      default: ''
    },
    learners: {
      type: String,
      default: ''
    }
  }
}
</script>

<style>
.languageSummary {
  width: 100%;
  word-break: break-word;
}
.ls {
  display: table;
  width: 100%;
}

.ls h5 {
  hyphens: auto;
  font-size: 0.8em;
  padding: 0 0.15em 0 0.25em;
  vertical-align: top;
  color: var(--color-gray, #6f6f70);
  font-weight: 500;
  padding-right: 1em;
}

.ls div {
  display: table-cell;
  width: 50%;
  vertical-align: bottom;
}
.languageSummary th {
  hyphens: auto;
  font-size: 0.7em;
  padding: 0 0.15em 0 0.25em;
  vertical-align: top;
  color: var(--color-gray, #6f6f70);
  border-left: 1px solid rgba(0, 0, 0, 0.2);
  font-weight: 500;
  padding-right: 1em;
}
.languageSummary th:first-child,
.languageSummary td:first-child {
  padding-left: 0;
  border-left: 0;
}
.languageSummary td {
  font-size: 0.8em;
  color: var(--color-gray, #6f6f70);
  font-weight: bold;
  border-left: 1px solid rgba(0, 0, 0, 0.2);
  padding: 0 0.15em 0 0.25em;
  padding-right: 1em;
  padding-top: 0.5em;
}
</style>
