from django.contrib.sitemaps import Sitemap
from language.models import Language, Community, PlaceName

class BaseSitemap(Sitemap):
    changefreq = "never"
    priority = 0.5

    def lastmod(self, obj):
        return obj.modified

    def format_name(self, name):
        name = name.lower()
        name = name.replace('\\', r'')
        name = name.replace('/', r'')
        name = name.replace('>', r'')
        name = name.replace('<', r'')
        name = name.replace('?', r'')
        name = name.replace(')', r'')
        name = name.replace('()', r'')
        name = name.replace('~', r'')
        name = name.replace('!', r'')
        name = name.replace('@', r'')
        name = name.replace('#', r'')
        name = name.replace('$', r'')
        name = name.replace('%', r'')
        name = name.replace('^', r'')
        name = name.replace('&', r'')
        name = name.replace('*', r'')
        name = name.replace('=', r'')
        name = name.replace('+', r'')
        name = name.replace(']', r'')
        name = name.replace('[', r'')
        name = name.replace('{', r'')
        name = name.replace('}', r'')
        name = name.replace('|', r'')
        name = name.replace(';', r'')
        name = name.replace(':', r'')
        name = name.replace('_', r'')
        name = name.replace('.', r'')
        name = name.replace(',', r'')
        name = name.replace('`', r'')
        name = name.replace('\'', r'')
        name = name.replace('  ', r'-')
        name = name.replace(' ', r'-')

        return name

class LanguageSitemap(BaseSitemap):
    changefreq = "never"
    priority = 0.5

    def items(self):
        return Language.objects.all()

    def location(self,obj):
        return '/languages/' + self.format_name(obj.name)


class CommunitySitemap(BaseSitemap):
    changefreq = "never"
    priority = 0.5

    def items(self):
        return Community.objects.all()

    def location(self,obj):
        return '/content/' + self.format_name(obj.name)


class PlaceNameSitemap(BaseSitemap):
    changefreq = "never"
    priority = 0.5

    def items(self):
        return PlaceName.objects.all()

    def location(self,obj):
        return '/place-names/' + self.format_name(obj.name)
