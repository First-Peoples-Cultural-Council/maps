<template>
  <div>
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
.languageSummary th {
  font-size: 0.7em;
  padding: 0 0.5em;
  vertical-align: top;
  color: var(--color-gray);
  border-left: 1px solid rgba(0, 0, 0, 0.2);
  font-weight: 500;
  padding-right: 1em;
}
.languageSummary td {
  font-size: 0.8em;
  color: var(--color-gray);
  font-weight: bold;
  border-left: 1px solid rgba(0, 0, 0, 0.2);
  padding: 0 0.5em;
  padding-right: 1em;
  padding-top: 0.5em;
}
</style>
