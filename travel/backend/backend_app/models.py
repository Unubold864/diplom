from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin

# Custom UserManager to handle user creation
class UserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)  # Hash the password before saving
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(email, password, **extra_fields)

# Custom User model that extends AbstractBaseUser and PermissionsMixin
class User(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True)
    name = models.CharField(max_length=100)
    
    # Default fields provided by AbstractBaseUser and PermissionsMixin
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    # Attach the custom manager
    objects = UserManager()

    # Specify the field to use as the unique identifier (username is replaced by email)
    USERNAME_FIELD = 'email'
    
    # Fields required for creating a user (besides email and password)
    REQUIRED_FIELDS = ['name']

    # Define related names to avoid clashes with auth.User model
    groups = models.ManyToManyField(
        'auth.Group',
        related_name='custom_user_set',
        blank=True,
        help_text='The groups this user belongs to.',
        verbose_name='groups',
    )
    user_permissions = models.ManyToManyField(
        'auth.Permission',
        related_name='custom_user_permissions_set',
        blank=True,
        help_text='Specific permissions for this user.',
        verbose_name='user permissions',
    )

    def __str__(self):
        return self.name


class RecommendedPlace(models.Model):
    name = models.CharField(max_length=255, default="Unknown")
    image = models.ImageField(max_length=200)
    rating = models.FloatField()
    location = models.CharField(max_length=255)
    description = models.TextField(default="Unknown")  # New field for description
    phone_number = models.CharField(max_length=20,default="Unknown")  # New field for phone number
    hotel_rating = models.CharField(max_length=50,default="Unknown")  # New field for hotel rating
    latitude = models.FloatField(null=True)
    longitude = models.FloatField(null=True)
    
    def __str__(self):
        return self.location
    
    
class PlaceImage(models.Model):
    place = models.ForeignKey(RecommendedPlace, related_name='images', on_delete=models.CASCADE)
    image = models.ImageField(upload_to='place_images/')
    
    def __str__(self):
        return f"Image for {self.place.name}"
    
    
class Place(models.Model):
    name = models.CharField(max_length=100)
    location = models.CharField(max_length=200)
    description = models.TextField()
    phone_number = models.CharField(max_length=20)
    rating = models.FloatField()
    hotel_rating = models.CharField(max_length=20)
    main_image = models.URLField()
    
    def __str__(self):
        return self.name

class Restaurant(models.Model):
    place = models.ForeignKey(RecommendedPlace, on_delete=models.CASCADE, related_name='restaurants')
    name = models.CharField(max_length=100)
    rating = models.FloatField()
    cuisine = models.CharField(max_length=100)
    image = models.ImageField(
        upload_to='restaurants/',  # This will create a 'restaurants' subfolder in MEDIA_ROOT
        max_length=200,
        blank=True,  # Allow empty images
        null=True,   # Allow NULL in database
        default=None  # Explicit default
    )
    @property
    def image_url(self):
        if self.image and hasattr(self.image, 'url'):
            return self.image.url
        return None  # Or return a default image path
    
    description = models.TextField()
    opening_hours = models.CharField(max_length=50)
    phone = models.CharField(max_length=20)
    
    def __str__(self):
        return f"{self.name} ({self.place.name})"