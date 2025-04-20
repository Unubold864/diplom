from django.contrib import admin
from .models import User, RecommendedPlace, PlaceImage

# Custom User Admin
class UserAdmin(admin.ModelAdmin):
    list_display = ('name', 'email', 'password')
    search_fields = ('name', 'email')

# Inline for PlaceImage
class PlaceImageInline(admin.TabularInline):
    model = PlaceImage
    extra = 3

# RecommendedPlace Admin with inline images
@admin.register(RecommendedPlace)
class RecommendedPlaceAdmin(admin.ModelAdmin):
    inlines = [PlaceImageInline]

# Register User separately
admin.site.register(User, UserAdmin)

# If you want to register PlaceImage separately (optional)
# admin.site.register(PlaceImage)