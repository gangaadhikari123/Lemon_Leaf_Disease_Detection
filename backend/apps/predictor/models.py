from django.db import models


class PredictionHistory(models.Model):

    image = models.ImageField(upload_to="history/")

    is_lemon_leaf = models.BooleanField(default=False)

    disease = models.CharField(
        max_length=100,
        null=True,
        blank=True
    )

    confidence = models.FloatField(default=0.0)

    treatment = models.TextField(null=True, blank=True)

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.disease}"