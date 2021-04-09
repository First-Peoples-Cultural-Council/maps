from django_filters import Filter


class ListFilter(Filter):
    def filter(self, qs, value):
        if value not in (None, ''):
            strings = [v for v in value.split(',')]
            print(strings)
            return qs.filter(**{'%s__%s' % (self.field_name, self.lookup_expr): strings})
        return qs
