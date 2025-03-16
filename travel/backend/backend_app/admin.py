from django.contrib import admin
from .models import User  # Import your model

# Optional: Customize how the model appears in the admin interface
class UserAdmin(admin.ModelAdmin):
    list_display = ('name', 'email', 'password')  # Fields to display in the list view
    search_fields = ('name', 'email')  # Enable search by name and email

# Register the model with the admin site
admin.site.register(User, UserAdmin)
