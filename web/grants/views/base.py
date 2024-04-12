from rest_framework import viewsets


class BaseGenericViewSet(viewsets.GenericViewSet):
    """
    Abstract base viewset that allows multiple serializers depending on action.
    """

    def get_serializer_class(self):
        if self.action != "list":
            if hasattr(self, "detail_serializer_class"):
                return self.detail_serializer_class

        return super().get_serializer_class()
