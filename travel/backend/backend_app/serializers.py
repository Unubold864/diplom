from rest_framework import serializers
from .models import User, RecommendedPlace

class UserSerializer(serializers.ModelSerializer):
    # Password field that is write-only (won't be returned in responses)
    password = serializers.CharField(
        write_only=True,
        required=True,
        style={'input_type': 'password'}
    )

    class Meta:
        model = User
        fields = ['id', 'email', 'name', 'password']
        extra_kwargs = {
            'email': {'required': True},
            'name': {'required': True}
        }

    def create(self, validated_data):
        # Use the custom create_user method from UserManager
        user = User.objects.create_user(
            email=validated_data['email'],
            password=validated_data['password'],
            name=validated_data['name']
        )
        return user

class RecommendedPlaceSerializer(serializers.ModelSerializer):
    class Meta:
        model = RecommendedPlace
        fields = '__all__'