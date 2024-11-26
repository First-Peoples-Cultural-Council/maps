from drf_yasg.inspectors import SwaggerAutoSchema
import inspect


class CustomOpenAPISchema(SwaggerAutoSchema):
    def get_summary_and_description(self):
        """
        Get description and summary from docstring if it's provided. Otherwise, use the default behavior.
        """

        docstring = inspect.getdoc(self.view)
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
                    # description from docstring... do summary magic
                    summary, description = self.split_summary_from_description(
                        description
                    )

        return summary, description
