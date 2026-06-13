# predictor/treatments.py
# Treatment recommendations for each disease
# Both English and Nepali supported

TREATMENTS = {
    "healthy": {
        "en": {
            "status": "Healthy",
            "description": "Your lemon leaf is healthy. No disease detected.",
            "treatment": [],
            "prevention": [
                "Water regularly but avoid overwatering",
                "Ensure proper sunlight (6-8 hours daily)",
                "Fertilize every 2-3 months",
                "Inspect leaves weekly for early signs",
            ],
            "severity": "none",
        },
        "np": {
            "status": "स्वस्थ",
            "description": "तपाईंको कागतीको पात स्वस्थ छ। कुनै रोग देखिएन।",
            "treatment": [],
            "prevention": [
                "नियमित पानी दिनुहोस् तर धेरै नदिनुहोस्",
                "राम्रो घाम लाग्ने ठाउँमा राख्नुहोस् (दैनिक ६-८ घण्टा)",
                "हरेक २-३ महिनामा मल हाल्नुहोस्",
                "हप्तामा एकपटक पात जाँच गर्नुहोस्",
            ],
            "severity": "none",
        }
    },

    "citrus_canker": {
        "en": {
            "status": "Citrus Canker Detected",
            "description": "Citrus canker is a bacterial disease causing raised brown lesions with yellow halos on leaves.",
            "treatment": [
                "Remove and destroy all infected leaves and branches immediately",
                "Apply copper-based bactericide (Copper Oxychloride 50% WP) at 3g/litre",
                "Spray Streptomycin Sulphate 90% + Tetracycline 10% at 0.5g/litre",
                "Avoid working with plants when wet to prevent spread",
                "Disinfect all pruning tools with 70% alcohol after each cut",
            ],
            "prevention": [
                "Use disease-free certified planting material",
                "Apply preventive copper spray before rainy season",
                "Avoid overhead irrigation",
                "Maintain good air circulation between plants",
            ],
            "severity": "high",
        },
        "np": {
            "status": "सिट्रस क्यान्कर रोग देखियो",
            "description": "यो ब्याक्टेरियाजन्य रोग हो जसले पातमा खैरो दाग र पहेँलो घेरा बनाउँछ।",
            "treatment": [
                "संक्रमित पात र हाँगाहरू तुरुन्त हटाई नष्ट गर्नुहोस्",
                "कपर अक्सिक्लोराइड ५०% WP — ३ ग्राम प्रति लिटर पानीमा मिसाई छर्नुहोस्",
                "स्ट्रेप्टोमाइसिन सल्फेट — ०.५ ग्राम प्रति लिटर पानीमा मिसाई छर्नुहोस्",
                "ओसिलो अवस्थामा बोटसँग सम्पर्क नगर्नुहोस्",
                "काट्ने औजारहरू ७०% अल्कोहलले सफा गर्नुहोस्",
            ],
            "prevention": [
                "रोगमुक्त बिरुवा मात्र प्रयोग गर्नुहोस्",
                "वर्षाअघि कपर स्प्रे गर्नुहोस्",
                "माथिबाट पानी नदिनुहोस्",
                "बोटहरूबीच राम्रो हावा चल्ने व्यवस्था गर्नुहोस्",
            ],
            "severity": "high",
        }
    },

    "greasy_spot": {
        "en": {
            "status": "Greasy Spot Detected",
            "description": "Greasy spot is a fungal disease causing oily-looking yellow spots, mainly on the underside of leaves.",
            "treatment": [
                "Apply Copper Hydroxide (Kocide) at 3-4g/litre every 3 weeks",
                "Spray oil-based fungicide (Petroleum oil 2%) to smother the fungus",
                "Remove heavily infected leaves and dispose of properly",
                "Apply Propiconazole 25% EC at 1ml/litre for severe infections",
            ],
            "prevention": [
                "Remove fallen leaves from the ground promptly",
                "Apply copper spray at petal fall stage",
                "Avoid wetting foliage during irrigation",
                "Maintain tree vigor through proper nutrition",
            ],
            "severity": "medium",
        },
        "np": {
            "status": "ग्रीसी स्पट रोग देखियो",
            "description": "यो ढुसीजन्य रोग हो जसले पातको तल्लो भागमा तेल जस्तो पहेँलो दाग बनाउँछ।",
            "treatment": [
                "कपर हाइड्रोक्साइड — ३-४ ग्राम प्रति लिटर, हरेक ३ हप्तामा छर्नुहोस्",
                "पेट्रोलियम तेल आधारित ढुसीनाशक (२%) छर्नुहोस्",
                "धेरै संक्रमित पातहरू हटाउनुहोस्",
                "गम्भीर अवस्थामा प्रोपिकोनाजोल १ मिली/लिटर प्रयोग गर्नुहोस्",
            ],
            "prevention": [
                "झरेका पातहरू तुरुन्त सफा गर्नुहोस्",
                "फूल झरेपछि कपर स्प्रे गर्नुहोस्",
                "पातहरू नभिज्ने गरी पानी दिनुहोस्",
                "उचित मलखाद दिई बोट बलियो राख्नुहोस्",
            ],
            "severity": "medium",
        }
    },

    "sooty_mold": {
        "en": {
            "status": "Sooty Mold Detected",
            "description": "Sooty mold is a black powdery fungus growing on honeydew secreted by insects like aphids and whiteflies.",
            "treatment": [
                "First control the insects causing honeydew: spray Imidacloprid 17.8% SL at 0.5ml/litre",
                "Wash affected leaves gently with mild soap water to remove mold",
                "Apply neem oil spray (5ml/litre) to control insects and fungus together",
                "Apply Carbendazim 50% WP at 1g/litre for severe mold",
            ],
            "prevention": [
                "Control aphids and whiteflies regularly",
                "Use yellow sticky traps to monitor insect population",
                "Avoid excess nitrogen fertilizer which attracts insects",
                "Encourage natural predators like ladybugs",
            ],
            "severity": "medium",
        },
        "np": {
            "status": "सुटी मोल्ड रोग देखियो",
            "description": "यो कालो धुलो जस्तो ढुसी हो जो लाही र सेतो झिँगाले छाड्ने मह जस्तो पदार्थमा उम्रिन्छ।",
            "treatment": [
                "पहिले कीरा नियन्त्रण गर्नुहोस्: इमिडाक्लोप्रिड ०.५ मिली/लिटर छर्नुहोस्",
                "प्रभावित पातहरू साबुन पानीले बिस्तारै धुनुहोस्",
                "नीम तेल (५ मिली/लिटर) छर्नुहोस्",
                "गम्भीर अवस्थामा कार्बेन्डाजिम १ ग्राम/लिटर प्रयोग गर्नुहोस्",
            ],
            "prevention": [
                "लाही र सेतो झिँगा नियमित नियन्त्रण गर्नुहोस्",
                "पहेँलो टाँसिने पासो प्रयोग गर्नुहोस्",
                "अत्यधिक नाइट्रोजन मल नहाल्नुहोस्",
                "प्राकृतिक शिकारी कीराहरू प्रोत्साहन गर्नुहोस्",
            ],
            "severity": "medium",
        }
    },

    "yellow_mosaic": {
        "en": {
            "status": "Yellow Mosaic Virus Detected",
            "description": "Yellow mosaic is a viral disease spread by whiteflies, causing irregular yellow-green patterns on leaves.",
            "treatment": [
                "There is NO cure for viral diseases — infected plants must be managed carefully",
                "Remove and destroy severely infected plants to prevent spread",
                "Control whitefly vectors immediately: Thiamethoxam 25% WG at 0.3g/litre",
                "Apply reflective mulches to repel whiteflies",
                "Spray neem oil (5ml/litre) every 7 days to reduce insect vectors",
            ],
            "prevention": [
                "Use virus-resistant lemon varieties if available",
                "Install insect-proof nets in nurseries",
                "Remove and destroy infected plant material immediately",
                "Control whitefly populations before planting season",
            ],
            "severity": "high",
        },
        "np": {
            "status": "पहेँलो मोजेक भाइरस देखियो",
            "description": "यो भाइरस रोग सेतो झिँगाद्वारा फैलिन्छ र पातमा पहेँलो-हरियो अनियमित बान्की बनाउँछ।",
            "treatment": [
                "भाइरस रोगको कुनै उपचार छैन — संक्रमित बोट सावधानीपूर्वक व्यवस्थापन गर्नुहोस्",
                "गम्भीर रूपमा संक्रमित बोट उखेलेर नष्ट गर्नुहोस्",
                "सेतो झिँगा नियन्त्रण: थियामेथोक्साम ०.३ ग्राम/लिटर छर्नुहोस्",
                "परावर्तक मल्च प्रयोग गरी झिँगा भगाउनुहोस्",
                "नीम तेल (५ मिली/लिटर) हरेक ७ दिनमा छर्नुहोस्",
            ],
            "prevention": [
                "रोग प्रतिरोधी कागती जातको बिरुवा प्रयोग गर्नुहोस्",
                "नर्सरीमा जालीको छाना लगाउनुहोस्",
                "संक्रमित बोट तुरुन्त नष्ट गर्नुहोस्",
                "रोपाइअघि सेतो झिँगा नियन्त्रण गर्नुहोस्",
            ],
            "severity": "high",
        }
    },

    "powdery_mildew": {
        "en": {
            "status": "Powdery Mildew Detected",
            "description": "Powdery mildew is a fungal disease causing white powdery patches on leaf surfaces, usually near veins.",
            "treatment": [
                "Spray Wettable Sulphur 80% WP at 2-3g/litre every 10-14 days",
                "Apply Myclobutanil 10% WP at 1g/litre for severe cases",
                "Use potassium bicarbonate spray (10g/litre) as organic option",
                "Remove heavily infected leaves and dispose of away from farm",
            ],
            "prevention": [
                "Avoid overhead irrigation — water at the base",
                "Improve air circulation by proper pruning",
                "Avoid excess nitrogen which promotes soft growth",
                "Apply preventive sulphur spray at start of dry season",
            ],
            "severity": "medium",
        },
        "np": {
            "status": "पाउडरी मिल्ड्यु रोग देखियो",
            "description": "यो ढुसीजन्य रोग हो जसले पातको सतहमा सेतो धुलो जस्तो दाग बनाउँछ।",
            "treatment": [
                "भिज्ने गन्धक (Wettable Sulphur) ८०% — २-३ ग्राम/लिटर, हरेक १०-१४ दिनमा",
                "गम्भीर अवस्थामा माइक्लोब्युटानिल १ ग्राम/लिटर छर्नुहोस्",
                "जैविक विकल्प: पोटासियम बाइकार्बोनेट १० ग्राम/लिटर",
                "धेरै संक्रमित पात हटाई नाश गर्नुहोस्",
            ],
            "prevention": [
                "माथिबाट पानी नदिनुहोस्",
                "काँटछाँट गरी हावा चल्ने व्यवस्था गर्नुहोस्",
                "अत्यधिक नाइट्रोजन मल नहाल्नुहोस्",
                "सुख्खा मौसम शुरु हुनुअघि गन्धक स्प्रे गर्नुहोस्",
            ],
            "severity": "medium",
        }
    },
}


def get_treatment(disease_class: str, language: str = "en") -> dict:
    """
    Get treatment data for a disease class in the requested language.

    Args:
        disease_class: One of the Stage 2 class names.
        language:      'en' for English, 'np' for Nepali.

    Returns:
        Treatment dict with status, description, treatment steps, prevention.
    """
    lang = language if language in ("en", "np") else "en"
    data = TREATMENTS.get(disease_class, TREATMENTS["healthy"])
    return data.get(lang, data["en"])