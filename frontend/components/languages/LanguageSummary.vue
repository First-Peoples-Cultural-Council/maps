<template>
  <div>
    <ul class="list-style-none m-0 p-0 mb-4">
      <li>
        <span class="font-08 color-gray">Population:</span>
        <span class="font-08 font-weight-bold color-gray">{{
          population || 0
        }}</span>
      </li>

      <li>
        <span class="font-08 color-gray">Fluent Speakers:</span>
        <span class="font-08 font-weight-bold color-gray">{{
          speakers || 0
        }}</span>
      </li>

      <li>
        <span class="font-08 color-gray">Semi Speakers:</span>
        <span class="font-08 font-weight-bold color-gray">{{
          somewhat || 0
        }}</span>
      </li>

      <li>
        <span class="font-08 color-gray">Learners:</span>
        <span class="font-08 font-weight-bold color-gray">{{
          learners || 0
        }}</span>
      </li>

      <li>
        <span class="font-08 color-gray">Source:</span>
        <span class="font-08 font-weight-bold color-gray"
          ><a
            :href="`https://fpcc.ca/resource/language-status-report-2022/`"
            target="_blank"
            >Report on the Status of B.C. First Nations Languages 2022</a
          ></span
        >
      </li>
    </ul>

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
