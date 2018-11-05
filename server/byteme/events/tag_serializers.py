from rest_framework import serializers
from .tag import Tag

class TagSerializer(serializers.Serializer):
    name = serializers.CharField(required=False, allow_blank=True, max_length=100)
    rankingScore = serializers.DecimalField(required=False, decimal_places=0, max_digits=5)

    def create(self, validated_data):
        tag = Tag.objects.create(**validated_data)
        return tag

    def update(self, instance, validated_data):
        instance.name = validated_data.get('name', instance.name)
        instance.rankingScore = validated_data.get('rankingScore', instance.rankingScore)
        instance.save()
        return instance