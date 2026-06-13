from django.db import models

# Create your models here.

# predictor/models.py
from django.db import models

class PredictionRecord(models.Model):
    """Stores every prediction made through the API."""

    image        = models.ImageField(upload_to='uploads/')
    is_lemon     = models.BooleanField(default=False)
    stage1_class = models.CharField(max_length=50)
    stage1_conf  = models.FloatField()
    stage2_class = models.CharField(max_length=50, blank=True, null=True)
    stage2_conf  = models.FloatField(blank=True, null=True)
    final_label  = models.CharField(max_length=50)
    message      = models.TextField()
    created_at   = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.final_label} ({self.stage1_conf:.0%}) — {self.created_at:%Y-%m-%d %H:%M}"

    class Meta:
        ordering = ['-created_at']