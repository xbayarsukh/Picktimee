from rest_framework import serializers
from .models import CalendarEvent

class CalendarEventSerializer(serializers.ModelSerializer):
    class Meta:
        model = CalendarEvent
        fields = ['event_id', 'service', 'description', 'start_time', 'end_time', 'customer', 'worker', 'branch']

