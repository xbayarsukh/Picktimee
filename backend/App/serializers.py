from rest_framework import serializers
from .models import CalendarEvent
from .models import Service

class CalendarEventSerializer(serializers.ModelSerializer):
    class Meta:
        model = CalendarEvent
        fields = ['event_id', 'service', 'description', 'start_time', 'end_time', 'customer', 'worker', 'branch']

class ServiceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Service  
        fields = ['service_id', 'sname', 'sprice', 'sduration']  