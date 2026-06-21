from .treatments import treatment_map


def normalize_class_name(name: str) -> str:
    mapping = {
        "anthracnose": "Anthracnose",
        "bacterial blight": "Bacterial Blight",
        "citrus canker": "Citrus Canker",
        "curl virus": "Curl Virus",
        "deficiency leaf": "Deficiency Leaf",
        "dry leaf": "Dry Leaf",
        "healthy leaf": "Healthy Leaf",
        "sooty mould": "Sooty Mould",
        "spider mites": "Spider Mites",
    }
    return mapping.get(name.strip().lower(), name)


def get_treatment(disease_name: str):
    disease_name = normalize_class_name(disease_name)
    data = treatment_map.get(disease_name)

    if not data:
        return {
            "en": {
                "status": "Unknown Disease",
                "treatment": ["Consult agricultural expert"],
                "prevention": [],
                "severity": "unknown"
            },
            "np": {
                "status": "अज्ञात रोग",
                "treatment": ["कृषि विशेषज्ञसँग परामर्श गर्नुहोस्"],
                "prevention": [],
                "severity": "unknown"
            }
        }

    return {
        "en": data["en"],
        "np": data["np"]
    }