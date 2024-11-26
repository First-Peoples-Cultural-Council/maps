from drf_yasg.inspectors import SwaggerAutoSchema
import inspect


class CustomOpenAPISchema(SwaggerAutoSchema):
    def get_summary_and_description(self):
        """
        Get description and summary from docstring if it's provided. Otherwise, use the default behavior.
        """

        docstring = self._sch.get_description(self.path, self.method) or ""
        if docstring:
            description = docstring
            summary = docstring.split("\n")[0]
        else:
            description = self.overrides.get("operation_description", None)
            summary = self.overrides.get("operation_summary", None)
            if description is None:
                description = self._sch.get_description(self.path, self.method) or ""
                description = description.strip().replace("\r", "")

                if description and (summary is None):
                    summary, description = self.split_summary_from_description(
                        description
                    )

        # If there's no description, set it to the summary for consistency
        if summary and not description:
            description = summary

        return summary, description
