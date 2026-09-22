-- Persona configuration seed data for Aoi and Lotta.
-- Run after the persona configuration tables and persona rows exist.
-- Re-running this file does not duplicate rows identified by the natural keys below.
BEGIN;

-- Aoi: character specification
INSERT INTO personyx.persona_character_specs (persona_id, name, target_model, is_default, config_json)
SELECT p.id, 'Aoi', 'ebaraPony', TRUE, '{
    "name": "Aoi",
    "target_model": "ebaraPony",
    "config_paths": {
        "workflow_path": "configs/personas/Aoi/workflows/api/aoi-IPAdapter9_fd5_strong_m_v0.33.0_1.json",
        "mod_config": "configs/personas/Aoi/workflows/templates/workflow_args.json",
        "faceid_reference_images_conf": "configs/personas/Aoi/assets/faceid_reference_images.json",
        "camera_conf": "configs/personas/Aoi/assets/camera.json",
        "environment_conf": "configs/personas/Aoi/assets/environments.json",
        "expression_conf": "configs/personas/Aoi/assets/expressions.json",
        "scene_conf": "configs/personas/Aoi/assets/scene.json",
        "wardrobe_conf": "configs/personas/Aoi/assets/wardrobe.json"
    },
    "rating": {
        "safe": "rating_safe",
        "questionable": "rating_questionable",
        "explicit": "rating_explicit"
    },
    "base_score_tags": "(score_9, score_8_up:1.2)",
    "base_style": "1980s retro anime style, Haruhiko Mikimoto style, cinematic grain, shakerato",
    "base_identity_tags": "1girl",
    "body_parts": {
        "hair": ["(pure black hair:1.3)", "long hair"],
        "eyes": ["blue eyes"],
        "accesories": {
            "head": ["(pink headphones worn on head:1.3)"],
            "neck": ["(leather choker:1.2)"]
        }
    },
    "negative_holy_grail": "score_4, score_5, score_6, low quality, bad anatomy, text, watermark",
    "negative_base": "(headphones_around_neck:1.2), (headphones_on_shoulders:1.2), (sunglasses:1.1), (goggles:1.1), (eyewear on head:1.1), (visor:1.1), (head-mounted display:1.2), (glasses:1.1), (anime:1.3), 3d, render, blurry, lowres, bad hands, error, blurry",
    "negative_face": "(grimace:1.2), (bad_teeth:1.3), (crooked_teeth:1.2), (scary_smile:1.2)",
    "innerwear_thresholds": {
        "1": 0,
        "2": 20,
        "3": 85,
        "4": 100
    },    
    "negative_logic": {
        "items": [
            {
                "id": "neg_base_defense",
                "description": "全レベル共通：現代風と低品質を排除する基本防壁",
                "tags": "(plastic_texture:1.1)",
                "min_lv": 1, "max_lv": 5, "weight": 1.0
            },
            {
                "id": "neg_lv3_borderline",
                "description": "Lv1-3専用：下着は許可するが、乳首・性器・直接的露出を厳禁する防壁",
                "tags": "(nipples:1.0), (pussy:1.0), (extra fingers:1.2), (other''s hand:1.4), (hand on shoulder:1.1), (hug:1.1), (interacting:1.1), (2multiple girls:1.1), (group:1.2)",
                "min_lv": 3, "max_lv": 3, "weight": 1.2
            },
            {
                "id": "neg_lv4_reinforced",
                "description": "Lv4専用：過激なタグによる画風崩壊と、下品すぎる漫符を徹底拒絶",
                "tags": "(penis:1.1), (dick:1.1), (cock:1.1)",
                "min_lv": 4, "max_lv": 4, "weight": 1.0
            }
        ]
    }
}'
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_character_specs s WHERE s.persona_id = p.id AND s.name = 'Aoi');

-- Aoi: camera asset
INSERT INTO personyx.persona_assets (persona_id, asset_type, asset_key, payload)
SELECT p.id, 'camera', 'default', '{
    "camera_angles": [
        {
            "id": "80s_dramatic_slant",
            "name": "斜め構図（ダッチアングル）",
            "suggested_resolution": { "width": 1024, "height" : 1024 },
            "description": "心理的な揺らぎやドラマチックな転換点を示す、80年代OVAの象徴的アングル",
            "tags": "(dutch_angle:1.2), (tilted_frame:1.3), (cinematic_composition:1.2)",
            "vibe": "dramatic",
            "best_for": ["lv1", "lv2"]
        },
        {
            "id": "telephoto_intimacy",
            "name": "望遠レンズ・圧縮効果",
            "suggested_resolution": { "width": 832, "height" : 1216 },
            "description": "背景をぼかし、Aoiの存在感と繊細なディテール（髪、瞳）を際立たせる",
            "tags": "(extreme_close-up:1.4), (shallow_depth_of_field:1.5), (bokeh:1.3), (telephoto_lens:1.2), (long_focus:1.2)",
            "vibe": "intimate",
            "best_for": ["lv1", "lv2", "lv3"]
        },
        {
            "id": "wide_angle_distortion",
            "name": "広角レンズ・パース強調",
            "suggested_resolution": { "width": 1216, "height" : 832 },
            "description": "手前を大きく、奥を小さく。室内での圧迫感や、四つん這い時のパースを強調する",
            "tags": "(wide_angle_lens:1.3), (perspective_distortion:1.2), (foreshortening:1.4), (fish-eye_lens:0.8)",
            "vibe": "dynamic",
            "best_for": ["lv2", "lv4"]
        },
        {
            "id": "low_angle_authority",
            "name": "ローアングル・煽り",
            "suggested_resolution": { "width": 768, "height" : 1344 },
            "description": "見上げる視点。Aoiの脚のラインや、圧倒的な存在感を強調する",
            "tags": "(from_below:1.5), (low_angle:1.4), (worm''s_eye_view:1.2), (looking_up_at_Aoi:1.3)",
            "vibe": "powerful",
            "best_for": ["lv2", "lv3", "lv4"]
        },
        {
            "id": "high_angle_fragility",
            "name": "ハイアングル・俯瞰",
            "suggested_resolution": { "width": 1216, "height" : 832 },
            "description": "見下ろす視点。Aoiの小ささや、守ってあげたくなるような脆弱さを演出",
            "tags": "(from_above:1.5), (high_angle:1.4), (bird''s_eye_view:1.2), (looking_down_at_Aoi:1.3)",
            "vibe": "observational",
            "best_for": ["lv1", "lv2", "lv3", "lv4"]
        },
        {
            "id": "over_the_shoulder_voyer",
            "name": "肩越し・覗き見視点",
            "description": "第三者の存在を感じさせる、没入感と背徳感のある構図",
            "suggested_resolution": { "width": 1216, "height" : 832 },
            "tags": "(over_the_shoulder:1.4), (point_of_view:1.2), (partial_obscured_view:1.1), (voyeuristic_shot:1.3)",
            "vibe": "storytelling",
            "best_for": ["lv1", "lv4"]
        },
        {
            "id": "back_view_allure",
            "name": "背面視点・バックビュー",
            "suggested_resolution": { "width": 1024, "height" : 1024 },
            "description": "キャラクターの背後からの視点。背中のラインやヒップ、また視線の先にある風景を強調する",
            "tags": "(back_view:1.4), (view_from_behind:1.4), (from_behind:1.4), (solo:1.2)",
            "vibe": "mysterious",
            "best_for": ["lv1", "lv2", "lv3", "lv4"]
        }
    ]
}'
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_assets a WHERE a.persona_id = p.id AND a.asset_type = 'camera' AND a.asset_key = 'default');

-- Aoi: environments asset
INSERT INTO personyx.persona_assets (persona_id, asset_type, asset_key, payload)
SELECT p.id, 'environments', 'default', '{
    "locations": [
        {
            "id": "classroom_desk", 
            "tags": "classroom, sitting at desk", 
            "description": "教室の机に座っている情景", 
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "classroom_window", 
            "tags": "classroom, near window", 
            "description": "窓際の教室の情景", 
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "library_bookshelf", 
            "tags": "library, by bookshelf", 
            "description": "本棚のある図書館の情景", 
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "library_reading_area", 
            "tags": "library, reading area", 
            "description": "読書エリアのある図書館の情景", 
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "cafe_table", 
            "tags": "cafe, at table", 
            "description": "カフェのテーブル席の情景", 
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "school_corridor", 
            "tags": "school corridor", 
            "description": "学校の廊下の情景", 
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "school_rooftop", 
            "tags": "school rooftop", 
            "description": "学校の屋上の情景", 
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "city_street", 
            "tags": "city street, urban", 
            "description": "都市の通りの情景", 
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit", "gym_uniform"]
        },
        {
            "id": "park_bench", 
            "tags": "park, on bench", 
            "description": "公園のベンチに座っている情景", 
            "not_compatible_outfits": ["lingerie_only", "bunny_suit"]
        },
        {
            "id": "beach_shore", 
            "tags": "beach, seashore", 
            "description": "海岸の情景", 
            "not_compatible_outfits": ["classic_sailor", "blazer_style", "gym_uniform", "oversized_hoodie", "office_lady", "miko_outfit", "yukata"]
        },
        {
            "id": "mountain_path", 
            "tags": "mountain path, forest", 
            "description": "山道の情景", 
            "not_compatible_outfits": ["classic_sailor", "blazer_style", "office_lady", "evening_dress", "turtleneck", "bunny_suit", "lingerie_only", "nurse_outfit", "china_dress"]
        },
        {
            "id": "japanese_garden", 
            "tags": "japanese garden, traditional", 
            "description": "日本庭園の情景", 
            "not_compatible_outfits": ["swimsuit_80s", "cyberpunk_outfits"]
        },
        {
            "id": "amusement_park", 
            "tags": "amusement park, rides", 
            "description": "遊園地の情景", 
            "not_compatible_outfits": ["lingerie_only", "bunny_suit"]
        },
        {
            "id": "shopping_mall", 
            "tags": "shopping mall, indoors", 
            "description": "ショッピングモールの情景", 
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "train_station", 
            "tags": "train station, platform", 
            "description": "駅のプラットフォームの情景", 
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "bus_stop", 
            "tags": "bus stop, urban", 
            "description": "バス停の情景", 
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "aquarium", 
            "tags": "aquarium, underwater exhibits", 
            "description": "水族館の情景", 
            "not_compatible_outfits": ["lingerie_only", "bunny_suit"]
        },
        {
            "id": "concert_hall", 
            "tags": "concert hall, stage", 
            "description": "コンサートホールの情景", 
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "art_museum", 
            "tags": "art museum, gallery", 
            "description": "美術館の情景", 
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "apartment_balcony", 
            "tags": "apartment, balcony, cityscape", 
            "description": "アパートのバルコニーからの都市の情景", 
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "bedroom_window", 
            "tags": "bedroom, by window", 
            "description": "寝室の窓際の情景", 
            "not_compatible_outfits": ["swimsuit_80s"]
        },
        {
            "id": "kitchen_counter", 
            "tags": "kitchen, at counter", 
            "description": "キッチンのカウンターの情景", 
            "not_compatible_outfits": [
                "classic_sailor", 
                "blazer_style", 
                "office_lady", 
                "evening_dress", 
                "miko_outfit", 
                "yukata", 
                "china_dress"
            ]
        },
        {
            "id": "shrine_grounds", 
            "tags": "shrine, peaceful grounds", 
            "description": "神社の境内、穏やかな情景", 
            "not_compatible_outfits": [
                "swimsuit_80s", 
                "cyberpunk_outfits"
            ]
        },
        {
            "id": "festival_night", 
            "tags": "japanese festival, night", 
            "description": "日本の祭りの夜の情景", 
            "not_compatible_outfits": [
                "swimsuit_80s", 
                "lingerie_only", 
                "bunny_suit"
            ]
        },
        {
            "id": "sci_fi_lab", 
            "tags": "sci-fi laboratory, futuristic", 
            "description": "SF研究所、未来的な情景", 
            "not_compatible_outfits": [
                "classic_sailor", 
                "blazer_style", 
                "gym_uniform", 
                "office_lady", 
                "miko_outfit", 
                "yukata", 
                "casual_outfits"
            ]
        },
        {
            "id": "cyberpunk_alley", 
            "tags": "cyberpunk alley, neon signs", 
            "description": "サイバーパンクな路地裏、ネオンサインの情景", 
            "not_compatible_outfits": [
                "classic_sailor", 
                "blazer_style", 
                "gym_uniform", 
                "office_lady", 
                "miko_outfit", 
                "yukata", 
                "casual_outfits"
            ]
        },
        {
            "id": "underwater_ruins", 
            "tags": "underwater ruins, ancient technology", 
            "description": "水中遺跡、古代技術の情景", 
            "not_compatible_outfits": [
                "classic_sailor", 
                "blazer_style", 
                "gym_uniform", 
                "oversized_hoodie", 
                "office_lady", 
                "sundress", 
                "tracksuit", 
                "miko_outfit", 
                "yukata", 
                "off_shoulder", 
                "evening_dress", 
                "turtleneck", 
                "china_dress"
            ]
        },
        {
            "id": "space_station", 
            "tags": "space station, zero gravity", 
            "description": "宇宙ステーション、無重力の情景", 
            "not_compatible_outfits": [
                "classic_sailor", 
                "blazer_style", 
                "gym_uniform", 
                "oversized_hoodie", 
                "office_lady", 
                "sundress", 
                "tracksuit", 
                "miko_outfit", 
                "yukata", 
                "off_shoulder", 
                "evening_dress", 
                "turtleneck", 
                "china_dress", 
                "swimsuit_80s"
            ]
        },
        {
            "id": "fantasy_forest", 
            "tags": "fantasy forest, magical glow", 
            "description": "幻想的な森、魔法の輝きの情景", 
            "not_compatible_outfits": [
                "classic_sailor", 
                "blazer_style", 
                "gym_uniform", 
                "oversized_hoodie", 
                "office_lady", 
                "sundress", 
                "tracksuit", 
                "bunny_suit", 
                "lingerie_only", 
                "nurse_outfit", 
                "china_dress", 
                "swimsuit_80s", 
                "sci_fi_lab", 
                "cyberpunk_alley", 
                "underwater_ruins", 
                "space_station"
            ]
        },
        {
            "id": "hotel_suite_night",
            "tags": "luxury hotel suite, night view, large bed, dim lighting",
            "description": "高級ホテルのスイートルーム。夜景の見える大きなベッドでの親密なシチュエーション。",
            "not_compatible_outfits": ["gym_uniform", "school_uniform", "classic_sailor", "tracksuit"]
        },
        {
            "id": "glass_shower_room",
            "tags": "steamy glass shower room, wet floor, bathroom",
            "description": "湯気のこもったガラス張りのシャワールーム。濡れた肌や透け感の演出に適した場所。",
            "not_compatible_outfits": ["blazer_style", "office_lady", "miko_outfit", "yukata", "evening_dress", "turtleneck", "oversized_hoodie"]
        },
        {
            "id": "private_sauna",
            "tags": "private sauna, wooden interior, dim warm lighting, steam",
            "description": "プライベートサウナ。木製の室内と薄暗い照明、汗ばんだ肌の質感を強調する空間。",
            "not_compatible_outfits": ["classic_sailor", "blazer_style", "office_lady", "evening_dress", "turtleneck", "china_dress", "school_uniform"]
        },
        {
            "id": "infirmary_afternoon",
            "tags": "school infirmary, medical office, curtained bed, afternoon sunlight",
            "description": "放課後の保健室。カーテンで仕切られたベッドなど、背徳的な放課後のシチュエーション。",
            "not_compatible_outfits": ["evening_dress", "china_dress", "cyberpunk_outfits", "bunny_suit"]
        },
        {
            "id": "night_poolside",
            "tags": "swimming pool, poolside, night, moonlit water",
            "description": "夜のプールサイド。月明かりと水面の反射が美しい、静かでスリルのある屋外空間。",
            "not_compatible_outfits": ["office_lady", "turtleneck", "miko_outfit", "yukata", "evening_dress"]
        },
        {
            "id": "elevator_interior",
            "tags": "inside elevator, mirrored walls, closed space",
            "description": "エレベーター内。鏡張りの壁と密閉された空間による、逃げ場のない緊張感。",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "cinema_back_row",
            "tags": "movie theater, back row seats, dark, cinematic lighting",
            "description": "映画館の最後列。暗闇の中で周囲を気にするような、秘め事のニュアンスを持つ場所。",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "gym_uniform", "bunny_suit"]
        },
        {
            "id": "photo_studio",
            "tags": "photography studio, lighting equipment, softbox, backdrop",
            "description": "撮影スタジオ。照明機材に囲まれた、「見られている」ことを意識した人工的な空間。",
            "not_compatible_outfits": []
        },
        {
            "id": "abandoned_factory",
            "tags": "abandoned factory, ruins, rusty pipes, concrete walls, dramatic shadows",
            "description": "無人の廃工場。冷たいコンクリートと柔らかな肌のコントラストを強調するロケーション。",
            "not_compatible_outfits": ["office_lady", "sundress", "evening_dress"]
        },
        {
            "id": "traditional_washitsu",
            "tags": "japanese room, tatami, futon, paper lantern, sliding doors",
            "description": "伝統的な和室。畳の上に敷かれた布団と行灯の光が、しっとりとした和の情緒を演出。",
            "not_compatible_outfits": ["cyberpunk_outfits", "sci_fi_lab", "swimsuit_80s"]
        },
        {
            "id": "throne_room",
            "tags": "throne room, royal palace, grand architecture, red carpet",
            "description": "豪華な玉座の間。支配的な雰囲気や、高貴な身分のキャラクターに相応しい空間。",
            "not_compatible_outfits": ["gym_uniform", "tracksuit", "oversized_hoodie", "casual_outfits"]
        },
        {
            "id": "dungeon_cell",
            "tags": "prison cell, dungeon, stone walls, iron bars, shackles",
            "description": "地下牢。石壁と鉄格子、拘束具などが似合うダークでハードなシチュエーション。",
            "not_compatible_outfits": ["office_lady", "sundress", "business_suit"]
        },
        {
            "id": "ritual_altar",
            "tags": "ritual altar, magic circle, glowing runes, dark fantasy",
            "description": "儀式の祭壇。輝く魔法陣と怪しい光に包まれた、神秘的で淫靡なファンタジー空間。",
            "not_compatible_outfits": ["office_lady", "business_suit", "gym_uniform", "tracksuit"]
        }
    ],
    "lightings": [
        {"id": "golden_hour", "tags": "golden hour lighting", "description": "夕焼け時の柔らかい光", "not_compatible_outfits": []},
        {"id": "soft_natural", "tags": "soft natural light", "description": "穏やかな自然光", "not_compatible_outfits": []},
        {"id": "dim_light", "tags": "dim light, cozy", "description": "薄暗く、心地よい光", "not_compatible_outfits": []},
        {"id": "backlighting", "tags": "backlighting, silhouette", "description": "逆光、シルエットを強調する光", "not_compatible_outfits": []},
        {"id": "neon_glow", "tags": "neon glow, vibrant", "description": "ネオンの光、鮮やかな雰囲気", "not_compatible_outfits": ["classic_sailor", "miko_outfit"]},
        {"id": "spotlight", "tags": "spotlight, dramatic", "description": "スポットライト、劇的な光", "not_compatible_outfits": []},
        {"id": "moonlight", "tags": "moonlight, serene", "description": "月明かり、静寂な雰囲気", "not_compatible_outfits": []},
        {"id": "sunlight_filtering", "tags": "sunlight filtering through, dappled light", "description": "木漏れ日、差し込む柔らかな光", "not_compatible_outfits": []},
        {"id": "strobe_light", "tags": "strobe light, chaotic", "description": "ストロボライト、混沌とした光", "not_compatible_outfits": ["classic_sailor", "miko_outfit", "yukata", "office_lady"]},
        {"id": "candlelight", "tags": "candlelight, warm glow", "description": "キャンドルの光、温かい輝き", "not_compatible_outfits": ["gym_uniform", "swimsuit_80s"]}
    ],
    "textures": [
        {"id": "cinematic_grain", "tags": "cinematic grain, filmic", "description": "映画のような粒状感、フィルム風", "not_compatible_outfits": []},
        {"id": "dust_particles", "tags": "dust particles, atmospheric haze", "description": "舞い散る埃、雰囲気のある霞", "not_compatible_outfits": []},
        {"id": "bokeh_blur", "tags": "bokeh, soft focus", "description": "ボケ効果、柔らかな焦点", "not_compatible_outfits": []},
        {"id": "rain_drops", "tags": "rain drops on window, wet", "description": "窓の雨粒、濡れた質感", "not_compatible_outfits": ["swimsuit_80s", "beach_shore", "mountain_path"]},
        {"id": "steam_haze", "tags": "steam, hazy atmosphere", "description": "湯気、霞んだ雰囲気", "not_compatible_outfits": ["beach_shore", "school_rooftop"]},
        {"id": "glitter", "tags": "glitter, sparkling", "description": "きらめき、輝く表現", "not_compatible_outfits": ["classic_sailor", "gym_uniform", "office_lady"]},
        {"id": "subtle_smoke", "tags": "subtle smoke, mysterious", "description": "かすかな煙、神秘的な雰囲気", "not_compatible_outfits": []},
        {"id": "lens_flare", "tags": "lens flare, bright", "description": "レンズフレア、明るい光の反射", "not_compatible_outfits": []},
        {"id": "watercolor_effect", "tags": "watercolor effect, artistic", "description": "水彩画のような効果、芸術的な表現", "not_compatible_outfits": []},
        {"id": "pixel_art", "tags": "pixel art style, retro game aesthetic", "description": "ピクセルアート調、レトロゲームの美学", "not_compatible_outfits": ["classic_sailor", "blazer_style", "gym_uniform", "office_lady", "miko_outfit", "yukata", "off_shoulder", "sundress", "tracksuit", "evening_dress", "turtleneck", "bunny_suit", "lingerie_only", "nurse_outfit", "china_dress", "swimsuit_80s"]}
    ]
}'
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_assets a WHERE a.persona_id = p.id AND a.asset_type = 'environments' AND a.asset_key = 'default');

-- Aoi: expressions asset
INSERT INTO personyx.persona_assets (persona_id, asset_type, asset_key, payload)
SELECT p.id, 'expressions', 'default', '{
    "expressions": [
        {
            "id": "smile",
            "name": "笑顔",
            "tags": "(soft smile:1.2), (crinkly eyes:1.15), (blushing cheeks:1.1)",
            "min_lv": 1,
            "max_lv": 3,
            "weight": 1.2
        },
        {
            "id": "pouting",
            "name": "膨れっ面",
            "tags": "(pouting:1.3), (pouty lips:1.2), (annoyed expression:1.15), (averting gaze:1.1), (blushing cheeks:1.1)",
            "min_lv": 1,
            "max_lv": 3,
            "weight": 0.8
        },
        {
            "id": "startled",
            "name": "驚き",
            "tags": "(startled expression:1.25), (wide eyes:1.15), (gasping:1.2), surprised look, (looking at viewer:1.15)",
            "min_lv": 1,
            "max_lv": 3,
            "weight": 1.1
        },
        {
            "id": "smirk",
            "name": "挑発",
            "tags": "(smirk:1.35), (seductive smile:1.15), (confident expression:1.2), (narrowed eyes:1.1)",
            "min_lv": 1,
            "max_lv": 2,
            "weight": 0.8
        },
        {
            "id": "melancholic",
            "name": "哀愁",
            "tags": "(melancholic expression:1.25), (wistful look:1.2), (pensive:1.1), (parted lips:1.1), (averting gaze:1.15)",
            "min_lv": 1,
            "max_lv": 3,
            "weight": 0.8
        },
        {
            "id": "bedroom eyes",
            "name": "恍惚",
            "tags": "(bedroom eyes:1.3), (heavy eyelids:1.2), (parted lips:1.15), (expression of pleasure:1.2), (slight blush:1.1)",
            "min_lv": 3,
            "max_lv": 4,
            "weight": 1.0
        }
    ]
}'
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_assets a WHERE a.persona_id = p.id AND a.asset_type = 'expressions' AND a.asset_key = 'default');

-- Aoi: scene asset
INSERT INTO personyx.persona_assets (persona_id, asset_type, asset_key, payload)
SELECT p.id, 'scene', 'default', '{
    "_scene_group_catalog": {
        "bottom_exposure": "下半身・下着露出系",
        "top_exposure": "上半身・胸元露出系",
        "innerwear_exposure": "下着露出全般",
        "clothing_destruction": "衣装破壊系",
        "wind_effect": "風による衣装変化",
        "high_risk": "特定レベル以上の強い表現",
        "intimacy": "近距離・親密な構図",
        "restraint": "拘束・強制姿勢を含む構図",
        "sexual_activity": "性的行為・道具を含む構図",
        "transparency": "濡れ・透け・布越しの描写"
    },
    "scene_logic": [
        {
            "id": "lv1_window_side_dreaming",
            "description": "窓際での物思い。{camera}により、外を眺める横顔だけでなく、室内側からの引きや俯瞰も可能に",
            "tags": "(looking_out_window:1.5), (looking_afar:1.3), (profile:1.2), (from_side:1.1), {camera}, sitting_at_desk, (head_tilt:1.1), (arm_on_desk:1.1), (sunlight_filtering_through:1.2), (backlighting:1.1), (dust_particles:1.2)",
            "min_lv": 1, "max_lv": 2, "weight": 4.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            }
        },
        {
            "id": "lv1_reading_immersion",
            "description": "読書に没頭。{camera}を(low_angle)にすれば見上げる読姿、(high_angle)なら手元の本への集中を強調",
            "tags": "(reading_book:1.4), (holding_open_book:1.3), (looking_down_at_book:1.3), sitting_at_desk, {camera}, leaning_forward, (focus_on_hand:1.1), (hair_falling_over_face:1.3), (delicate_eyelashes:1.2), soft_expression",
            "min_lv": 1, "max_lv": 2, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            } 
        },
        {
            "id": "lv1_afterschool_napping",
            "description": "居眠り。{camera}で机に突っ伏した彼女を真上から捉える(high_angle)や、横からの接写が可能",
            "tags": "(sleeping_at_desk:1.5), (slumped_over_desk:1.5), {camera}, (eye_level:1.2), head_on_arms, (arms_crossed:1.1), (disheveled_hair:1.3), closed_eyes, peaceful_expression, (soft_diffused_light:1.2)",
            "min_lv": 1, "max_lv": 2, "weight": 1.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            } 
        },
        {
            "id": "lv1_listening_music",
            "description": "ヘッドフォン没入。{camera}が(dutch_angle)ならエモーショナルに、(close-up)なら指先の表情を捉える",
            "tags": "(listening_to_music:1.4), (closed_eyes:1.4), (eyelids_shut:1.4), (hands_on_headphones:1.4), sitting, {camera}, (resting_cheek_on_hand:1.3), (hand_on_face:1.2), (delicate_fingers:1.2), (gentle_shadows:1.1), cinematic_vibe",
            "min_lv": 1, "max_lv": 2, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            } 
        },
        {
            "id": "lv1_adjusting_choker",
            "description": "【ボツ】チョーカーを直す。{camera}を(low_angle)にすることで、首筋のラインと顎のラインの重なりを魅せる",
            "tags": "(hand_near_choker:1.5), (reaching_towards_neck:1.4), (one_hand_raised:1.3), {camera}, standing, (neck_focus:1.3), (looking_at_viewer:1.1), (sole_focus:1.4), (only_one_person:1.3), (fixing_choker_pose:1.2)",
            "min_lv": 0, "max_lv": 0, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            } 
        },
        {
            "id": "lv1_tucking_hair_behind_ear",
            "description": "髪を耳にかける。{camera}で(side_profile)や(medium_shot)を組み合わせ、首筋のラインと指先の繊細さを強調",
            "tags": "{camera}, (tucking_hair_behind_ear:1.4), (hand_to_head:1.2), (solo:1.2)",
            "min_lv": 1, "max_lv": 2, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            }
        },
        {
            "id": "lv1_walking_corridor",
            "description": "廊下を歩く。{camera}で(wide_shot)なら放課後の静寂、(telephoto)なら彼女を追うような視点に",
            "tags": "(walking_in_school_corridor:1.3), (walking_away:1.2), {camera}, (cowboy_shot:1.3), (hair_fluttering:1.4), (backlighting:1.2), (looking_sideways:1.1), (detailed_face:1.3)",
            "min_lv": 1, "max_lv": 2, "weight": 1.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            } 
        },
        {
            "id": "lv1_walking_path",
            "description": "場所を問わず歩くシーン。{location}との組み合わせで、放課後、オフィス街、廃墟などに対応可能。",
            "tags": "(walking:1.3), (walking_away:1.2), (step_forward:1.1), {camera}, (cowboy_shot:1.3), (hair_fluttering:1.4), (backlighting:1.2), (looking_sideways:1.1), (detailed_face:1.3)",
            "min_lv": 1, "max_lv": 2, "weight": 1.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            }
        },
        {
            "id": "lv2_shy_glance",
            "description": "照れ隠し。{camera}を(dutch_angle)にすれば不安定な心情、(high_angle)なら上目遣いの強調に",
            "tags": "{camera}, (looking_away:1.3), (shy_glance:1.4), (playing_with_hair:1.2), (blushing:1.4), (tucking_hair_behind_ear:1.3), standing, (delicate_fingers:1.2)",
            "min_lv": 2, "max_lv": 3, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            } 
        },
        {
            "id": "lv2_staring_contest",
            "description": "凝視。{camera}を(low_angle)にすれば圧倒的な存在感、(telephoto)なら彼女の瞳の虹彩まで描画",
            "tags": "{camera}, (staring:1.4), (looking_at_viewer:1.5), (deep_blush:1.2), (parted_lips:0.9), (intense_eyes:1.3), standing, (unwavering_gaze:1.2)",
            "min_lv": 2, "max_lv": 3, "weight": 1.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            }
        },
        {
            "id": "lv2_leaning_on_shoulder",
            "scene_groups": ["intimacy"],
            "description": "無防備な近接。{camera}を(over_the_shoulder)にすれば、彼女の体温を感じるような没入感のある構図に",
            "tags": "sitting_close, {camera}, (shoulder_touch:0.9), (looking_at_viewer:1.1), (gentle_smile:1.2), (soft_lighting:1.3), evening_light, (hair_touching_viewer:1.1)",
            "min_lv": 2, "max_lv": 3, "weight": 1.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            } 
        },
        {
            "id": "lv2_whisper_close",
            "scene_groups": ["intimacy"],
            "description": "内緒話。{camera}に(close-up)や(side_view)を組み合わせることで、吐息が聞こえる距離感を演出",
            "tags": "{camera}, (leaning_towards_viewer:1.4), (looking_at_viewer:1.2), (whispering:1.1), (blushing:1.3), (parted_lips:1.1), soft_expression, (hand_near_mouth:1.2), (delicate_fingers:1.1)",
            "min_lv": 2, "max_lv": 3, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            } 
        },
        {
            "id": "lv2_fixing_hair_tie",
            "description": "髪を結い直す。{camera}で(from_side)や(back_view)を選べば、首筋から脇にかけてのラインを官能的に捉える",
            "tags": "{camera}, (arms_up:1.4), (fixing_hair:1.3), (exposed_neck:1.3), (exposed_armpits:1.2), (blushing:1.1), standing, (ponytail:1.1), (stretched_fabric:1.2)",
            "min_lv": 2, "max_lv": 3, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            } 
        },
        {
            "id": "lv2_leaning_closer_curiosity",
            "description": "覗き込み。{camera}を(low_angle)にすれば、カメラ（視聴者）を上から覗き込むようなドミナントな構図に",
            "tags": "{camera}, (leaning_forward:1.5), (looking_down_at_viewer:1.4), (curious_expression:1.2), (hair_falling_forward:1.4), (close_distance:1.3), (deep_blush:1.2), (watery_eyes:1.1)",
            "min_lv": 2, "max_lv": 3, "weight": 1.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            } 
        },
        {
            "id": "lv2_phys_cleavage_peek",
            "scene_groups": ["top_exposure", "innerwear_exposure"],
            "description": "胸元の油断。前かがみの姿勢で緩んだ襟元から、ブラジャーのカップや谷間が露わになる",
            "tags": "(leaning_forward:1.5), (bent_over:1.2), (downblouse:1.4), (view_into_shirt:1.3), (bra_visible:1.2), {camera}, (cowboy_shot:1.3), (foreshortening:1.3), (hands_on_knees:1.2), (looking_up:1.1), (gap_in_clothing:1.3), (upper_body_focus:1.1), (blush:1.2), (solo:1.3)",
            "min_lv": 2, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": false
            } 
        },
        {
            "id": "lv2_fixing_uniform_button",
            "description": "制服のボタンを留め直す。{camera}で(close-up)や(upper_body_focus)を組み合わせ、指先の繊細さと胸元のディテールを強調",
            "tags": "{camera}, (buttoning:1.7), (adjusting_clothes:1.5), (fingers_on_button:1.6), (hands_on_own_chest:1.4), (looking_down:1.4), (waist_up:1.3), (delicate_fingers:1.3), (focused_expression:1.2), (buttons:1.4), (front_buttons:1.2), (no_extra_hands:1.5), (solo:1.3)",
            "min_lv": 2, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": false
            }
        },
        {
            "id": "lv2_leaning_against_railing",
            "scene_groups": ["bottom_exposure", "wind_effect"],
            "description": "バルコニーや屋上の手摺への寄りかかり。{camera}の(low_angle)で空の広さを、(back_view)で風になびく髪と孤独感を演出",
            "tags": "(leaning_on_railing:1.5), (looking_at_horizon:1.3), {camera}, ({target_fabric_outer_bottom}_flip:1.4), ({target_fabric_outer_bottom}_wind:1.3), (wind_blown_hair:1.4), (school_rooftop:1.3), (distant_cityscape:1.2), (sunset_sky:1.3), (skylight:1.2), (peaceful_moment:1.1)",
            "min_lv": 1, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv2_5_phys_sitting_gap",
            "scene_groups": ["bottom_exposure", "innerwear_exposure"],
            "description": "【着座の油断】無防備な足元",
            "tags": "{camera}, (sitting:1.2), (spread_legs:1.1), ({target_fabric_outer_bottom}_spread:1.3), (view_from_low_angle:1.4), (panty_peek:1.4), (cluttered_desk:1.1)",
            "min_lv": 2, "max_lv": 3, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv2_5_env_stair_climb",
            "scene_groups": ["bottom_exposure", "innerwear_exposure"],
            "description": "【階段の遠近法】高低差による露出",
            "tags": "(walking_up_stairs:1.2), from_below, (upskirt:1.3), (cinematic_angle:1.2), (leg_focus:1.2), (panty_peek:1.3)",
            "min_lv": 2, "max_lv": 3, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv2_5_phys_high_reach",
            "scene_groups": ["bottom_exposure", "top_exposure", "innerwear_exposure"],
            "description": "【背伸びと延伸】裾の限界",
            "tags": "(from_below:1.5), (low_angle:1.4), (standing_on_tiptoe:1.5), (heels_up:1.4), (arching_back:1.4), (arms_stretched_up:1.3), (interlocked_fingers:1.2), (stretching:1.3), (looking_up:1.2), (armpits:1.3), (ribs:1.1), ({target_fabric_outer_bottom}_riding_up:1.4), (panty_focus:1.3), (crotch_focus:1.2)",
            "min_lv": 2, "max_lv": 3, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv2_5_phys_bending_peek",
            "scene_groups": ["bottom_exposure", "top_exposure", "innerwear_exposure"],
            "description": "【屈伸の死角】前傾姿勢",
            "tags": "(bending_over:1.5), (leaning_forward:1.4), (back_three-quarter_view:1.4), (diagonal_view:1.2), (from_side:1.1), (low_angle:1.4), (from_below:1.2), ({target_fabric_outer_bottom}_lift:1.1), (upskirt:1.2), (panty_peek:1.2), ({target_fabric_outer_bottom}_gap:1.3), (embarrassed:1.2), (accidental:1.1), (looking_at_viewer:1.2), (looking_down:1.1)",
            "min_lv": 2, "max_lv": 3, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv2_5_env_windy_front",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "wind_effect"],
            "description": "【前方・風の悪戯】自然な浮き上がり",
            "tags": "(from_below:1.5), (low_angle:1.4), (worm''s_eye_view:1.2), (looking_up:1.3), (wind_blowing_{target_fabric_outer_bottom}:1.4), ({target_fabric_outer_bottom}_lift:1.3), (hand_on_{target_fabric_outer_bottom}:1.2), (embarrassed:1.2), (wide eyes:1.2), (panty_peek:1.3)",
            "min_lv": 2, "max_lv": 3, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            },
            "suggested_resolution": { "width": 832, "height" : 1216 }
        },
        {
            "id": "lv2_5_env_windy_back",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "wind_effect"],
            "description": "【後方・風の悪戯】自然な浮き上がり",
            "tags": "(view_from_behind:1.5), (back_view:1.4), (looking_back:1.3), (low_angle:1.4), (worm''s_eye_view:1.2), (wind_blowing_{target_fabric_outer_bottom}:1.4), ({target_fabric_outer_bottom}_lift:1.3), (hand_on_{target_fabric_outer_bottom}:1.2), (embarrassed:1.2), (wide eyes:1.2), (panty_peek:1.3)",
            "min_lv": 2, "max_lv": 3, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            },
            "suggested_resolution": { "width": 832, "height" : 1216 } 
        },
        {
            "id": "lv2_5_v_sit_exposure",
            "scene_groups": ["bottom_exposure", "innerwear_exposure"],
            "description": "【拒絶と羞恥の丸まり】自らを閉ざし、小さく丸まって震えるポーズ。膝を胸に引き寄せ、隠すように脚を閉じさせ",
            "tags": "sitting, knees_to_chest, (hug_own_knees:1.2), (own_legs_together:1.2), (own_knees_together:1.2), (crotch_focus:1.4), (extreme_close-up:1.3), (from_below:1.3), (delicate_collarbone:1.2), (looking_at_viewer:1.2), (cinematic_lighting:1.2)",
            "min_lv": 2, "max_lv": 3, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            },
            "suggested_resolution": { "width": 832, "height" : 1216 }
        },
        {
            "id": "lv3_phys_deep_squat",
            "scene_groups": ["bottom_exposure", "innerwear_exposure"],
            "description": "【Lv3:蹲踞の隙】かかとをつけたままの深いしゃがみ込み。閉じた膝の間から、逃げ場のない露出を捉える",
            "tags": "(crouching:1.4), (pigeon-toed:1.5), (knees_together:1.4), (knock_knees:1.3), (feet_spread:1.1), (upskirt:1.1), (panty_peek:1.4), (pussy_juice:1.3), (embarrassed:1.2), (solo:1.2)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv3_phys_deep_squat_wet",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "transparency"],
            "description": "【Lv3:蹲踞の隙】かかとをつけたままの深いしゃがみ込み。閉じた膝の間から、逃げ場のない露出を捉える - 濡れ濡れバージョン",
            "tags": "(crouching:1.4), (pigeon-toed:1.5), (knees_together:1.4), (knock_knees:1.3), (feet_spread:1.1), (upskirt:1.1), (wet_clothes:1.2), (wet_panties:1.5), (soaked_panties:1.4), (panty_peek:1.4), (embarrassed:1.2), (solo:1.2)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv3_phys_sitting_triangle_wet",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "transparency"],
            "description": "【Lv3:着座の聖域】椅子や床に座った際、太ももの付け根から覗く下着の「三角ゾーン」- 濡れ濡れバージョン",
            "tags": "(wide_angle_lens:1.3), (high_angle:1.3), (sitting:1.3), (knees_down:1.1), (knees_together:1.1), (pigeon-toed:1.2), (crotch_focus:1.2), (wet_clothes:1.1), (soaked_panties:1.5), (panty_peek:1.4)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            },
            "suggested_resolution": { "width": 1216, "height" : 832 }
        },
        {
            "id": "lv3_phys_sitting_triangle_stable",
            "scene_groups": ["bottom_exposure", "innerwear_exposure"],
            "description": "【Lv3:着座の聖域】椅子や床に座った際、太ももの付け根から覗く下着の「三角ゾーン」 - 視点真ん中寄り",
            "tags": "(wide_angle_lens:1.3), (perspective_distortion:1.2), (foreshortening:1.3), (high_angle:1.3), (sitting:1.3), (knees_down:1.4), (legs_closed:1.3), (leaning_forward:1.2), (from_below:1.3), ({target_fabric_outer_bottom}_lift:1.4), (crotch_focus:1.4), (panty_peek:1.4)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            },
            "suggested_resolution": { "width": 1216, "height" : 832 }
        },
        {
            "id": "lv3_true_shirt_disarray",
            "scene_groups": ["top_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "【Lv3:衣服の崩壊】肩のラインと胸元の「美樹本流」の影にリソースを集中",
            "tags": "{camera}, sitting, (off_shoulder:1.5), (shirt_hanging_off_shoulder:1.4), (bra_peeking:1.2), (subtle_cleavage:1.2), (upper_body_focus:1.3), (exposed_skin:1.3), (head_tilted_back:1.2), (half_closed_eyes:1.3), (heavy_breathing:1.2), (sweat:1.1), (no_extra_limbs:1.4)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": false
            } 
        },
        {
            "id": "lv3_true_bent_over_tease",
            "scene_groups": ["bottom_exposure", "innerwear_exposure"],
            "description": "【Lv3:屈曲の美】ヒップラインの食い込みと「振り返り」の解剖学的整合性",
            "tags": "{camera}, (all_fours:1.4), (bent_over:1.5), (looking_back:1.4), ({target_fabric_outer_bottom}_hitched_up:1.4), ({target_fabric_outer_bottom}_digging_into_flesh:1.3), (butt_focus:1.5), (intense_blush:1.3), (heavy_breathing:1.3), (sole_focus:1.2)",
            "min_lv": 3, "max_lv": 3, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv3_true_fetish_constriction",
            "scene_groups": ["bottom_exposure", "top_exposure", "high_risk"],
            "description": "【食い込みと張力】マクロ視点での肉の段差と、衣装の「締め付け」を強調",
            "tags": "{camera}, (macro_lens:1.3), (skin_indentation:1.6), (tight_clothing:1.4), ({target_fabric_outer_bottom}_digging_into_skin:1.5), (creasing_skin:1.4), (flesh_excess:1.3), (constriction:1.4), (heavy_breathing:1.2), (sweat_drops_on_skin:1.1)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv3_true_fetish_transparency",
            "scene_groups": ["top_exposure", "innerwear_exposure", "transparency"],
            "description": "【透けと吸着】『乳首禁止』を前提とした、布越しのシルエット描写",
            "tags": "{camera}, (wet_clothes:1.4), (translucent_{target_fabric_outer_top}:1.4), (see-through:1.1), ({target_fabric_outer_top}_clinging_to_body:1.5), (bra_visible_under_{target_fabric_outer_top}:1.2), (shivering:1.1), (watery_eyes:1.2), (sole_focus:1.3)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv3_true_shirt_shredded",
            "scene_groups": ["top_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "【Lv3:衣服の損壊】上着が激しく引き裂かれ、肩や背中が露出。布の破片が肌に張り付く。{camera}で(low_angle)にすれば、破れた布の立体感が強調される",
            "tags": "{camera}, (shredded_shirt:1.6), (torn_fabric:1.5), (ripped_clothes:1.4), (hanging_shreds_of_fabric:1.3), (bra_peeking:1.2), (exposed_skin:1.4), (heavy_breathing:1.3), (sweat:1.2), (disheveled_hair:1.2), (desperate_expression:1.1)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv3_true_skirt_torn",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "【Lv3:下衣の崩壊】{destructible_fabric}が縦に裂け、脚のラインが剥き出しになる。{camera}の(side_view)で裂け目のエッジを強調",
            "tags": "{camera}, {destructible_fabric}, (ripped_hem:1.2), (fabric_tears:1.2), (showing_thigh:1.2), (panty_peeking:1.5), (shivering:1.2), (looking_at_viewer:1.1)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv3_true_struggle_remnants",
            "scene_groups": ["top_exposure", "clothing_destruction"],
            "description": "【Lv3:抵抗の痕跡】襟元や袖が引きちぎられた状態。{camera}の(close-up)で、破れた布の『繊維のほつれ』を美樹本流の線で描く",
            "tags": "{camera}, (ripped_collar:1.5), (torn_sleeves:1.4), (damaged_clothing:1.3), (tattered_edges:1.4), (exposed_collarbone:1.3), (choker_visible:1.2), (ink_lines_on_torn_fabric:1.3), (rough_sketch_edges:1.1), (sobbing:1.1)",
            "min_lv": 3, "max_lv": 3, "weight": 2.0,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv3_true_skirt_shredded_stable",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "顔の崩れを防ぎつつ、下半身の破壊を確定させるハイブリッド画角",
            "tags": "{camera}, (cowboy_shot:1.3), (from_below:1.4), (lower_body_focus:1.2), (torn_{target_fabric_outer_bottom}:1.4), (panty_peeking:1.2), (crotch_focus:1.3), (detailed_face:1.2), (no_wounds:1.2)",
            "min_lv": 3, "max_lv": 3, "weight": 2.0,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv3_true_shirt_shredded_stable",
            "scene_groups": ["top_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "【上半身の損壊】{camera}によるドラマチックな画角と、激しい布の損壊を両立",
            "tags": "{camera}, (upper_body_focus:1.3), (cowboy_shot:1.2), (shredded_{target_fabric_outer_top}:1.5), (torn_fabric:1.5), (ripped_clothes:1.4), (hanging_shreds_of_fabric:1.3), (bra_peeking:1.2), (subtle_cleavage:1.2), (exposed_skin:1.3), (no_wounds:1.2), (clean_skin:1.3)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": false
            } 
        },
        {
            "id": "lv3_true_bent_over_tease_stable",
            "scene_groups": ["bottom_exposure", "innerwear_exposure"],
            "description": "【屈曲の美】背後や横からの{camera}演出を活かし、ヒップラインの食い込みを描く",
            "tags": "{camera}, (knee_up:1.3), (all_fours:1.4), (bent_over:1.5), (looking_back:1.4), ({target_fabric_outer_bottom}_hitched_up:1.4), ({target_fabric_outer_bottom}_digging_into_flesh:1.5), (butt_focus:1.5), (panty_visible:1.7), (shimapan:1.5), (intense_blush:1.3), (no_wounds:1.4), (clean_skin:1.3), (crotch_exposure:1.6), (underwear_visible:1.6)",
            "min_lv": 3, "max_lv": 3, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        { 
            "id": "lv3_true_hand_exploration",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "sexual_activity"],
            "description": "【自己愛】指先の湿感と、多指症を防ぐための「1本」制約",
            "tags": "{camera}, sitting, (fingers_in_mouth:1.5), (hand_on_own_crotch:1.3), (one_hand_on_crotch:1.3), (masturbation_gesture:1.2), ({target_fabric_outer_bottom}_lift:1.3), (spread_legs:1.2), (wet_lips:1.3)",
            "min_lv": 3, "max_lv": 3, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        { 
            "id": "lv3_true_hand_exploration_stable",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "sexual_activity"],
            "description": "【自己愛】{camera}の寄り具合を制御しつつ、一人での行為に限定",
            "tags": "{camera}, (cowboy_shot:1.3), (hand_on_own_crotch:1.3), (one_hand_on_crotch:1.3), (masturbation_gesture:1.2), ({target_fabric_outer_bottom}_lift:1.4), (spread_legs:1.3)",
            "min_lv": 3, "max_lv": 4, "weight": 1.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv3_true_fetish_transparency_stable",
            "scene_groups": ["bottom_exposure", "top_exposure", "innerwear_exposure", "transparency"],
            "description": "【透けと吸着】{camera}によるフェティッシュなアングルで、布越しの下着を描写",
            "tags": "{camera}, (cowboy_shot:1.3), (wet_clothes:1.3), (translucent_{target_fabric_outer_bottom}:1.4), (see-through:1.3), ({target_fabric_outer_bottom}_clinging_to_body:1.3), (bra_visible_under_{target_fabric_outer_top}:1.2), (panty_lines:1.3), (shivering:1.1), (no_wounds:1.4), (clean_skin:1.3)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv3_shredded_skirt_reveal",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "【Lv3:下半身の決壊】スカートが縦に大きく裂け、太ももから腰の下着が露わになる。{camera}で(low_angle)を指定すれば、裂け目の奥行きが強調される",
            "tags": "{camera}, (torn_{target_fabric_outer_bottom}:1.4), (ripped_{target_fabric_outer_bottom}:1.4), (exposed_panties:1.3), (knees_up:1.4), (holding_knees:1.3), (sitting:1.3), (thigh_focus:1.3), (crotch_focus:1.2), (no_standing:1.2)",
            "min_lv": 3, "max_lv": 3, "weight": 3.0,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv3_shredded_top_bra_reveal",
            "scene_groups": ["top_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "【Lv3:胸元の損壊】上着の前面が激しく引き裂かれ、中のブラジャーが完全に露出。{camera}を(close-up)にすれば、破れた布の繊維と肌の質感が際立つ",
            "tags": "{camera}, (upper_body_focus:1.4), (shredded_shirt:1.7), (torn_clothing:1.6), (ripped_front:1.5), (bra_visible:1.7), (cleavage_focus:1.5), clothed_nipples, (detailed_face:1.2), (clean_skin:1.4), (no_wounds:1.5)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },            
        {
            "id": "lv3_phys_panty_pull_down",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "sexual_activity"],
            "description": "【Lv3:ギリギリの境界線】前かがみの姿勢で、両手で下着の端をわずかに押し下げる仕草。性器露出を避けつつ背徳感を強調",
            "tags": "(leaning_forward:1.1), (hands_on_thighs:1.1), (hands_on_panties:1.3), (pulling_down_own_panties:1.3), (no_panties:1.4), (three-quarter_view:1.2), (from_front:1.1), (partial_obscured_view:1.1), (waist_up:1.3), (foreshortening:1.2), (looking_at_viewer:1.2), (blush:1.3), (embarrassed:1.1), (tight_clothing:1.1), (soft_skin_texture:1.2), (solo:1.3)",
            "min_lv": 3, "max_lv": 3, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            },
            "suggested_resolution": { "width": 1216, "height" : 832 }
        },
        {
            "id": "lv3_back_destruction_tease",
            "scene_groups": ["bottom_exposure", "top_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "【Lv3:背面の崩落】背中から腰にかけて衣装が消失。{camera}を(back_view)にすれば、食い込む下着のラインと無傷の背中が強調される",
            "tags": "(back_view:1.5), (looking_back:1.3), (torn_back_of_{target_fabric_outer_top}:1.4), (torn_{target_fabric_outer_bottom}:1.4), (shredded_fabric:1.4), (exposed_back:1.4), (panty_lines_subtle:1.3), (waist_focus:1.3), (clean_skin:1.4), (no_wounds:1.5), (blushing:1.2)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            }
        },
        {
            "id": "lv4_phys_torn_ecstasy",
            "scene_groups": ["top_exposure", "bottom_exposure", "high_risk", "clothing_destruction", "sexual_activity"],
            "description": "【衣服破壊の極致】自らの手で{target_fabric_outer_top}の襟元を掴み、左右に引き裂く。{camera}で(low_angle)にすれば、絶頂の表情と破壊された布のコントラストが際立つ",
            "tags": "{camera}, {destructible_fabric}, (shredded_fabric_on_skin:1.3), (clutching_cloth:1.2), (head_tilted_back:1.3), (climax:1.1), (nipples:1.1), (pussy:1.2), (sweat_on_collarbone:1.2), (saliva_thread:1.1)",
            "min_lv": 3, "max_lv": 4, "weight": 1.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv4_phys_forced_torn_ecstasy",
            "scene_groups": ["top_exposure", "high_risk", "clothing_destruction", "restraint"],
            "description": "【他動的破壊の極致】何者かに襟元を強く掴まれ、左右に引き裂かれる。{camera}で(low_angle)にすれば、翻弄される絶頂の表情と、無残に破られた布地のコントラストが際立つ",
            "tags": "{camera}, {destructible_fabric} ,(arms_up:1.4), (arms_above_head:1.4), (forced_posture:1.3), (shredded_{target_fabric_outer_top}:1.4), ({target_fabric_outer_top}_torn_vertically:1.4), (ripped_fabric:1.3), (barely_covered:1.3), (disheveled_clothes:1.3), (nipples_visible_through_disarray:1.3),(shame:1.3), (humiliation:1.3), (disgrace:1.2), (watery_eyes:1.2),(sobbing:1.1), (sweat_on_collarbone:1.2), (disheveled_hair:1.2), (no_extra_hands:1.3)",
            "min_lv": 4, "max_lv": 5, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": false
            }
        },
        {
            "id": "lv4_phys_disheveled_ecstasy",
            "scene_groups": ["top_exposure", "high_risk", "sexual_activity"],
            "description": "【着崩れの極致】自らの手で襟元を押し下げ、肌を露出させる。{camera}で(low_angle)にすれば、指が布地に食い込む質感と絶頂の表情が際立つ",
            "tags": "{camera}, (pulling_down_collar:1.4), (off_shoulder:1.3), (fingers_under_fabric:1.4), (disheveled_clothes:1.3), (closed_eyes:1.1), (head_tilted_back:1.1), (climax:1.1), (nipples_visible_through_disarray:1.2), (sweat_on_collarbone:1.1), (saliva_thread:1.1), (skin_redness:1.1)",
            "min_lv": 4, "max_lv": 5, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            },
            "camera_angle_exclude": [
                "back_view_allure"
            ]
        },
        {
            "id": "lv4_phys_toy_compression",
            "scene_groups": ["bottom_exposure", "top_exposure", "innerwear_exposure", "high_risk", "sexual_activity"],
            "description": "【性具の圧着】卵型バイブレーターを{target_fabric}（下着や裾）の隙間から押し当てる。{camera}で(close-up)にすれば、道具と肌の『食い込み』の質感を逃さない",
            "tags": "{camera}, (completely_undressed:1.2), (holding_vibrator:1.2), (pressing_vibrator_against_pussy:1.4), (skin_indentation_by_toy:1.4), (arms between legs:1.3), (spread_legs:1.3), (wet_pussy:1.4), (pussy_focus:1.1), (deep_blush:1.4), (watery_eyes:1.2), (only_one_girl:1.2), chiaroscuro",
            "min_lv": 4, "max_lv": 5, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv4_phys_toy_compression",
            "description": "【性具の圧着】スティック型バイブレーターを{target_fabric}（下着や裾）の隙間から押し当てる。{camera}で(close-up)にすれば、道具と肌の『食い込み』の質感を逃さない",
            "tags": "{camera}, (completely_undressed:1.2), (holding_dildo:1.3), (pressing_device_against_pussy:1.4), (skin_indentation_by_toy:1.5), (arms between legs:1.3), (spread_legs:1.3), (wet_pussy:1.4), (pussy_focus:1.1), (deep_blush:1.5), (watery_eyes:1.2), (only_one_girl:1.2), chiaroscuro",
            "min_lv": 4, "max_lv": 5, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv4_phys_bent_fabric_rip",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "high_risk", "clothing_destruction", "sexual_activity"],
            "description": "【背面と素材の干渉】四つん這いで、自らの指を{target_fabric}の穴や裾に引っ掛け、引き裂き広げる仕草。{camera}は(back_view)系を推奨",
            "tags": "(back_view:1.2), (from_behind:1.4), (all_fours:1.3), (bent_over:1.4), (completely_undressed:1.2), (looking_down:1.1), (crotch_focus:1.5), (self_spreading_{target_fabric_outer_bottom}:1.4), (hands_on_own_thighs:1.3), ({target_fabric_outer_bottom}_tugging:1.2), (pussy_visible:1.3), (wet_pussy:1.5), (hand_between_legs:1.2), (butt_focus:1.4), (sweat_on_back:1.1), (solo:1.5), detailed_ink_lines",
            "min_lv": 4, "max_lv": 5, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            },
            "suggested_resolution": { "width": 1216, "height" : 832 }
        },
        {
            "id": "lv4_phys_bent_fabric_rip_masturbation",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "high_risk", "sexual_activity"],
            "description": "【背面と素材の干渉】四つん這いで、自らの指または他者の指で愛撫される",
            "tags": "(back_view:1.2), (from_behind:1.4), (all_fours:1.3), (bent_over:1.4), (looking_down:1.1), (crotch_focus:1.5), (fingering:1.4), (hand_between_legs:1.5), (hand_on_pussy:1.4), (self_spreading:1.3), (pussy_visible:1.3), (wet_pussy:1.5), (stringy_fluids:1.2), (butt_focus:1.4), (shame:1.4), (blush:1.5), (heavy_breathing:1.3)",
            "min_lv": 4, "max_lv": 5, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            },
            "suggested_resolution": { "width": 1216, "height" : 832 }
        },
        {
            "id": "lv4_phys_bound_tension",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "high_risk", "restraint"],
            "description": "【拘束の張力】手首を縛られ、自ら上に引っ張ることで背中の反りを強調。{camera}で(side_view)や(low_angle)を選べば、体のラインが最も美しく描かれる",
            "tags": "{camera}, (cinematic_composition:1.2), (completely_undressed:1.2), (wrists_cuffed_above_head:1.4), (suspended_arms:1.3), (restraints:1.3), (arching_back:1.3), (strained_neck:1.3), (forced_posture:1.2), (sobbing:1.1), (crying_with_eyes_open:1.2), (shame:1.3), (disgrace:1.3), (body_fluids:1.2), ({target_fabric_outer_bottom}_lift:1.3), ({target_fabric_outer_bottom}_up:1.3), (wet_pussy:1.2), (thigh_highs_under_{target_fabric_outer_bottom}:1.2), (solo:1.5)",
            "min_lv": 4, "max_lv": 4, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            }
        },
        {
            "id": "lv4_lost_in_ecstasy_sprawl",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "high_risk", "sexual_activity"],
            "description": "【脱力と余韻】絶頂の後に力なく横たわる。{camera}を(high_angle)にすれば、散らばった{destructible_fabric}の残骸と[perssona]の対比が美しい",
            "tags": "lying_on_back, {camera}, (completely_undressed:1.3), (spread_legs:1.2), (disheveled_hair:1.2), (empty_eyes:1.2), (parted_lips:1.3), (deep_blush:1.2), (heavy_breathing:1.3), {destructible_fabric}, (pussy_visible:1.3), (wet_pussy:1.3), (sweat_glistening:1.1), (afterglow:1.2)",
            "min_lv": 4, "max_lv": 5, "weight": 3.0,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            }
        },
        {
            "id": "lv4_forced_humiliation_chains",
            "scene_groups": ["bottom_exposure", "top_exposure", "high_risk", "restraint", "clothing_destruction"],
            "description": "【屈辱の服従】快楽を排し、意思に反して繋がれた屈辱のみを描写。{camera}は(high_angle)で圧迫感を出し、無残に引き裂かれた{destructible_fabric}が尊厳の喪失を強調する",
            "tags": "(all_fours:1.4), (bent_over:1.3), (from_above:1.5), (high_angle:1.4), (bird''s_eye_view:1.2), (looking_down_at_Aoi:1.3), (completely_undressed:1.4), (heavy_iron_collar:1.5), (clanking_chains:1.3), forced_posture, (sobbing:1.1), (crying_with_eyes_open:1.2), (shame:1.3), (disgrace:1.3), (nipples:1.1), (pussy_visible:1.3), (butt_focus:1.4), {destructible_fabric}, (cold_sweat:1.2), (cinematic_grain:1.2)",
            "min_lv": 4, "max_lv": 5, "weight": 3.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            }
        },
        {
            "id": "lv4_forced_fingering_humiliation",
            "scene_groups": ["top_exposure", "bottom_exposure", "high_risk", "restraint", "sexual_activity"],
            "description": "【指による蹂躙】他者の指が秘部に潜り込み、強引に弄る。意思に反した生理的反応と、それを拒めない絶望を[persona]の表情に刻み込む",
            "tags": "{camera}, (fingering:1.4), (hand_between_legs:1.3), (fingers_inside:1.5), (clancy_pussy:1.2), (pussy_juice:1.3), (spreading_pussy:1.4), (looking_down_at_own_crotch:1.2), (shame:1.4), (sobbing:1.1), trembling, (completely_undressed:1.4), (heavy_iron_collar:1.5), (clanking_chains:1.2), (nipples:1.1), (deep_blush:1.3), (sweat_on_skin:1.2), (shakerato:1.2)",
            "min_lv": 4, "max_lv": 5, "weight": 3.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            }
        },
        {
            "id": "lv4_forced_breast_grab",
            "scene_groups": ["top_exposure", "high_risk", "restraint", "sexual_activity"],
            "description": "【胸部の蹂躙】他者の大きな手が、無防備な[persona]の胸を強引に掴み、指が肉に食い込む。逃れられない支配と、羞恥に染まる表情を強調する",
            "tags": "arms_up, (hands_above_head:1.2), (medium_breasts:1.4), (slender_body:1.3), (grabbing_another''s_breast:1.4), (large_hand_on_small_breast:1.3), (squeezing:1.3), (breast_indentation:1.4), (completely_undressed:1.4), (heavy_iron_collar:1.5), (shame:1.5), (disgrace:1.4), (trembling:1.3), (nipples:1.2), {destructible_fabric}",
            "min_lv": 4, "max_lv": 5, "weight": 3.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            }
        },
        {
            "id": "lv5_public_exhibition_cage",
            "scene_groups": ["top_exposure", "bottom_exposure", "high_risk", "restraint", "clothing_destruction"],
            "description": "大衆の好奇の視線に晒され、人間ではなく「見世物」として檻の中に配置された絶望。{camera}は檻の外からの視点をシミュレートし、圧倒的な孤立感と屈辱を描く",
            "tags": "(inside_iron_cage:1.5), (rusty_bars:1.3), (completely_undressed:1.4), (kneeling_on_all_fours:1.3), (heavy_iron_collar:1.5), (tethered_by_chains:1.4), (crowd_blurred_in_background:1.4), (multiple_pointing_hands:1.3), (shame:1.5), (disgrace:1.5), (crying_with_head_down:1.3), (shivering:1.3), (exposure:1.4), (cinematic_lighting:1.2)",
            "min_lv": 4, "max_lv": 5, "weight": 3.0,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": false
            }
        },
        {
            "id": "lv5_phys_bound_tension",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "high_risk", "restraint", "sexual_activity"],
            "description": "【拘束の張力】手首を縛られ、自ら上に引っ張ることで背中の反りを強調。{camera}で(side_view)や(low_angle)を選べば、体のラインが最も美しく描かれる",
            "tags": "{camera}, completely_undressed, (wrists_tied_above_head:1.5), (pulling_rope:1.3), (arching_back:1.4), (strained_neck:1.3), (climax:1.4), (body_fluids:1.2), (saliva_thread:1.4), ({target_fabric_outer_bottom}_lift:1.4),({target_fabric_outer_bottom}_up:1.4),(wet_pussy:1.2),(thigh_highs_under_{target_fabric_outer_bottom}:1.2), (partially_undressed:1.3), (half_closed_eyes:1.2), (lust:1.2), (solo:1.5), (restrained:1.3)",
            "min_lv": 4, "max_lv": 5, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            }
        }
    ]
}'
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_assets a WHERE a.persona_id = p.id AND a.asset_type = 'scene' AND a.asset_key = 'default');

-- Aoi: wardrobe asset
INSERT INTO personyx.persona_assets (persona_id, asset_type, asset_key, payload)
SELECT p.id, 'wardrobe', 'default', '{
    "colors": ["red", "blue", "green", "black", "white", "pink", "purple", "yellow"],
    "destructible_base_tags": {
        "normal": [
            "(shredded_{target_destructible_top}:1.4)",
            "(torn_{target_destructible_top}:1.4)", 
            "(ripped_{target_destructible_top}:1.4)",
            "({target_destructible_bottom}_torn_vertically:1.4)",
            "(fabric clinging to thighs:1.2)"
        ]
    },
    "outfits": [
        { 
            "id": "classic_sailor", 
            "tags": "classic sailor school uniform, pleated skirt, red neckerchief", 
            "vibe": "school", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["shirt", "skirt", "neckerchief"] ,
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "classic_sailor", "bottom": "skirt" }
        },
        { 
            "id": "classic_sailor_highsocks", 
            "tags": "classic sailor school uniform, pleated skirt, red neckerchief, (thighhighs:1.2)", 
            "vibe": "school", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["shirt", "skirt", "neckerchief", "thighhighs"] ,
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "classic_sailor", "bottom": "skirt", "socks": "thighhighs" }
        },
        { 
            "id": "china_dress", 
            "tags": "{color} china dress, short china dress, (deep side slit:1.5), (silk embroidery:1.2)", 
            "vibe": "sexy", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["dress"] ,
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "china dress", "bottom": "dress_hem" }
        },
        { 
            "id": "office_lady", 
            "tags": "office_lady, business_formal, tight_pencil_skirt, pantyhose", 
            "vibe": "mature", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["shirt", "skirt", "pantyhose"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "shirt", "bottom": "tight_pencil_skirt" }
        },
        { 
            "id": "lingerie_only", 
            "tags": "sheer babydoll, lace trim, matching stockings", 
            "vibe": "sexy", 
            "min_lv": 3, "max_lv": 4, 
            "destructible": true, 
            "parts": ["babydoll", "stockings"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "sheer_babydoll", "bottom": "babydoll_skirt" }
        },
        { 
            "id": "blazer_style", 
            "tags": "school blazer, plaid skirt, ribbon tie", 
            "vibe": "school", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["blazer", "shirt", "skirt"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "school_blazer", "bottom": "plaid_skirt" }
        },
        { 
            "id": "gym_uniform", 
            "tags": "bloomers, gym shirt, (white socks:1.1)", 
            "vibe": "school", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["t-shirt", "bloomers"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [
                "lv2_5_phys_bending_peek",
                "lv2_5_env_windy_front",
                "lv2_5_env_windy_back"
            ],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "gym_shirt", "bottom": "bloomers" }
        },
        { 
            "id": "oversized_hoodie", 
            "tags": "oversized techwear hoodie, tactical joggers, sneakers", 
            "vibe": "cyberpunk", 
            "min_lv": 1, 
            "max_lv": 3, 
            "destructible": false, 
            "parts": ["hoodie", "pants"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "oversized_hoodie", "bottom": "tactical_joggers" }
        },
        { 
            "id": "bodysuit", 
            "tags": "sleek cyber bodysuit, metallic accents, glowing lines", 
            "vibe": "cyberpunk", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": false, 
            "parts": ["suit"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "cyber_bodysuit", "bottom": "cyber_bodysuit" }
        },
        { 
            "id": "pilot_suit", 
            "tags": "80s mecha pilot suit, form-fitting, shoulder pads", 
            "vibe": "cyberpunk", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": false, 
            "parts": ["suit"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "pilot_suit", "bottom": "pilot_suit" }
        },
        { 
            "id": "off_shoulder", 
            "tags": "oversized off-shoulder knit sweater, denim shorts", 
            "vibe": "casual", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["knit", "shorts"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "off-shoulder_knit_sweater", "bottom": "denim_shorts" }
        },
        { 
            "id": "sundress", 
            "tags": "white summer sundress, straw hat, (thin fabric:1.1)", 
            "vibe": "casual", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["dress"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "sundress_top", "bottom": "sundress_skirt" }
        },
        { 
            "id": "tracksuit", 
            "tags": "80s retro tracksuit, side stripes, zip-up jacket", 
            "vibe": "casual", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["jacket", "pants"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "tracksuit_jacket", "bottom": "tracksuit_pants" }
        },
        { 
            "id": "evening_dress", 
            "tags": "elegant backless evening dress, high slit", 
            "vibe": "mature", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["dress"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "evening_dress_bodice", "bottom": "evening_dress_skirt" }
        },
        { 
            "id": "turtleneck", 
            "tags": "tight sleeveless turtleneck, mini skirt", 
            "vibe": "mature", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["knit", "skirt"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "sleeveless_turtleneck", "bottom": "mini_skirt" },
            "conflict_outfits": {
                "accesories_neck": [
                    "{accesories_neck_parts_tags} worn over (sleeveless_turtleneck:1.2)"
                ]
            }
        },
        { 
            "id": "bikini_armor", 
            "tags": "(bikini_armor:1.2), (armored_bikini:1.2), (metal_bikini:1.1), metallic plating, (fantasy_armor:1.2), leather straps, pauldrons", 
            "vibe": "fantasy", 
            "min_lv": 2, 
            "max_lv": 4, 
            "destructible": false, 
            "parts": ["armor", "straps"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "bikini_armor_top", "bottom": "bikini_armor_bottom" }
        },
        { 
            "id": "miko_outfit", 
            "tags": "(traditional_miko_outfit:1.2), (solid_white_kimono_top:1.3), (red_hakama:1.2)", 
            "vibe": "traditional", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["kosode", "hakama"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal", 
            "outer_tags": { "top": "white_kosode", "bottom": "red_hakama" }
        },
        { 
            "id": "yukata", 
            "tags": "floral pattern yukata, obi sash, wooden geta", 
            "vibe": "traditional", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["yukata", "obi"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "yukata_upper", "bottom": "yukata_skirt" }
        },
        { 
            "id": "bunny_suit", 
            "tags": "(high-leg bunny suit:1.5), bow tie, wrist cuffs", 
            "vibe": "sexy", 
            "min_lv": 2, 
            "max_lv": 4, 
            "destructible": false, 
            "parts": ["suit"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "bunny_suit", "bottom": "bunny_suit" }
        },
        { 
            "id": "nurse_outfit", 
            "tags": "retro nurse uniform, nurse cap, white stockings", 
            "vibe": "sexy", 
            "min_lv": 2, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["dress", "cap", "stockings"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "nurse_uniform_dress", "bottom": "nurse_uniform_skirt" }
        },
        { 
            "id": "swimsuit_80s", 
            "tags": "high-leg one-piece swimsuit, neon colors, 80s style", 
            "vibe": "sexy", 
            "min_lv": 2, 
            "max_lv": 4, 
            "destructible": false, 
            "parts": ["swimsuit"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "one-piece_swimsuit", "bottom": "one-piece_swimsuit" }
        },
        { 
            "id": "denim_setup", 
            "tags": "denim_jacket, button_front, denim_skirt, matching_denim_outfit, blue_denim, (thighhighs:1.2)", 
            "vibe": "casual", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["jacket", "skirt"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "denim_jacket", "bottom": "denim_skirt" }
        },
        { 
            "id": "culottes_white_shirt", 
            "tags": "white_dress_shirt, tucked_in, collared_shirt, navy_blue_culottes, skirt_pants", 
            "vibe": "school", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["shirt", "culottes"],
            "inincompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "shirt", "bottom": "culottes" }
        },
        { 
            "id": "recruit_suit", 
            "tags": "(business_suit:1.1), black suit, (tight_pencil_skirt:1.2), white_dress_shirt, black_pantyhose", 
            "vibe": "school", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["jacket", "shirt", "skirt", "pantyhose"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "jacket", "bottom": "formal_skirt" }
        },
        { 
            "id": "tank_top_casual", 
            "tags": "(tank_top:1.2), (scoop_neck:1.1), (colorful_tank_top:1.3), (random_color:1.1), tucked_in, tight_fit", 
            "vibe": "casual", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["tank_top", "underwear"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "tank_top", "bottom": "denim_shorts" }
        },
        { 
            "id": "kariyushi_wear", 
            "tags": "kariyushi_wear, (aloha_shirt:1.1), (floral_print:1.2), (hibiscus_print:1.2), (short_sleeves:1.2), (open_collar:1.3), (untucked:1.2), (lightweight_fabric:1.2), (button_up:1.1)", 
            "vibe": "casual", 
            "min_lv": 1, 
            "max_lv": 4, 
            "destructible": true, 
            "parts": ["kariyushi_shirt", "slacks", "underwear"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "kariyushi_shirt", "bottom": "slacks" }
        }
    ],
    "innerwear_sets": {
        "styles": [
            { 
                "id": "black_lace", 
                "tags": {
                    "top": "black_lace_bra",
                    "bottom": "black_lace_panties"
                },
                "vibe": "mature", 
                "min_lv": 2 
            },
            { 
                "id": "cyber_blue", 
                "tags": {
                    "top": "blue_sport_bra",
                    "bottom": "blue_panties"
                },
                "vibe": "cyberpunk", 
                "min_lv": 1 
            },
            { 
                "id": "pink_striped", 
                "tags": {
                    "top": "pink_and_white_striped_bra",
                    "bottom": "shimapan",
                    "bottom_other": "cute_bow"
                },
                "vibe": "cute", 
                "min_lv": 1 
            },
            { 
                "id": "minimal_black", 
                "tags": {
                    "top": "micro_bikini_style_bra",
                    "bottom": "black_thong",
                    "bottom_other": "(strappy:1.2)"
                },
                "vibe": "sexy", 
                "min_lv": 3 
            },
            { 
                "id": "white_pure", 
                "tags": {
                    "top": "simple_white_bra",
                    "bottom": "white_panties",
                    "bottom_other": "(satin:1.1)"
                },
                "vibe": "school", 
                "min_lv": 1 
            },
            { 
                "id": "no_bra_mode", 
                "tags": {
                    "top": "no_bra",
                    "top_other": "(nipples_visible_through_fabric:1.3)",
                    "bottom": "no_panties"
                },
                "vibe": "sexy", 
                "min_lv": 4 
            }
        ]
    }
}'
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_assets a WHERE a.persona_id = p.id AND a.asset_type = 'wardrobe' AND a.asset_key = 'default');

-- Aoi: faceid reference image node_9
INSERT INTO personyx.persona_asset_files (persona_id, asset_type, asset_key, file_url, file_name, mime_type)
SELECT p.id, 'faceid', 'node_9', 'https://personyx.r2.unchainworks.com/Aoi/faceid/aoi_ref_1.png', 'aoi_ref_1.png', 'image/png'
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_asset_files f WHERE f.persona_id = p.id AND f.asset_type = 'faceid' AND f.asset_key = 'node_9');

-- Aoi: faceid reference image node_41
INSERT INTO personyx.persona_asset_files (persona_id, asset_type, asset_key, file_url, file_name, mime_type)
SELECT p.id, 'faceid', 'node_41', 'https://personyx.r2.unchainworks.com/Aoi/faceid/aoi_ref_2.png', 'aoi_ref_2.png', 'image/png'
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_asset_files f WHERE f.persona_id = p.id AND f.asset_type = 'faceid' AND f.asset_key = 'node_41');

-- Aoi: faceid reference image node_43
INSERT INTO personyx.persona_asset_files (persona_id, asset_type, asset_key, file_url, file_name, mime_type)
SELECT p.id, 'faceid', 'node_43', 'https://personyx.r2.unchainworks.com/Aoi/faceid/aoi_ref_3.png', 'aoi_ref_3.png', 'image/png'
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_asset_files f WHERE f.persona_id = p.id AND f.asset_type = 'faceid' AND f.asset_key = 'node_43');

-- Aoi: faceid reference image node_47
INSERT INTO personyx.persona_asset_files (persona_id, asset_type, asset_key, file_url, file_name, mime_type)
SELECT p.id, 'faceid', 'node_47', 'https://personyx.r2.unchainworks.com/Aoi/faceid/aoi_ref_4.png', 'aoi_ref_4.png', 'image/png'
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_asset_files f WHERE f.persona_id = p.id AND f.asset_type = 'faceid' AND f.asset_key = 'node_47');

-- Aoi: faceid reference image node_48
INSERT INTO personyx.persona_asset_files (persona_id, asset_type, asset_key, file_url, file_name, mime_type)
SELECT p.id, 'faceid', 'node_48', 'https://personyx.r2.unchainworks.com/Aoi/faceid/aoi_ref_5.png', 'aoi_ref_5.png', 'image/png'
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_asset_files f WHERE f.persona_id = p.id AND f.asset_type = 'faceid' AND f.asset_key = 'node_48');

-- Aoi: faceid color match image
INSERT INTO personyx.persona_asset_files (persona_id, asset_type, asset_key, file_url, file_name, mime_type)
SELECT p.id, 'faceid', 'color_match', 'https://personyx.r2.unchainworks.com/Aoi/faceid/aoi_color_match_1.png', 'aoi_color_match_1.png', 'image/png'
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_asset_files f WHERE f.persona_id = p.id AND f.asset_type = 'faceid' AND f.asset_key = 'color_match');

-- Aoi: api workflow api/aoi-IPAdapter9_fd1.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'aoi-IPAdapter9_fd1.json', '{
  "5": {
    "inputs": {
      "seed": 205911805904494,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "ddpm",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 1216,
      "height": 832,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "7": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "8": {
    "inputs": {
      "filename_prefix": "aoi",
      "images": [
        "7",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "9": {
    "inputs": {
      "image": "20260220_192834_0.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ebaraPonyxlPonySDXL_v21.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 0,
      "weight_faceidv2": 3.5,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "9",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "(score_9, score_8_up:1.2), rating_questionable BREAK 1980s retro anime style, Haruhiko Mikimoto style, cinematic grain, shakerato BREAK 1girl,(pure black hair:1.3), long hair, blue eyes, (pink headphones worn on head:1.3), (leather choker:1.2) BREAK (startled expression:1.25), (wide eyes:1.15), (gasping:1.2), surprised look, (looking at viewer:1.15) BREAK (wide_angle_lens:1.3), (perspective_distortion:1.2), (foreshortening:1.3), (high_angle:1.3), (sitting:1.3), (knees_down:1.4), (legs_closed:1.3), (leaning_forward:1.2), (from_below:1.3), (skirt_lift:1.4), (crotch_focus:1.4), (panty_peek:1.4) BREAK classic sailor school uniform, pleated skirt, red neckerchief BREAK cafe, at table,soft natural light,subtle smoke, mysterious",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "score_4, score_5, score_6, low quality, bad anatomy, text, watermark, (plastic_texture:1.1), (nipples:1.0), (pussy:1.0), (extra fingers:1.2), (other''s hand:1.4), (hand on shoulder:1.1), (hug:1.1), (interacting:1.1), (2multiple girls:1.1), (group:1.2), (headphones_around_neck:1.2), (headphones_on_shoulders:1.2), (sunglasses:1.1), (goggles:1.1), (eyewear on head:1.1), (visor:1.1), (head-mounted display:1.2), (glasses:1.1), (anime:1.3), 3d, render, blurry, lowres, bad hands, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 0.8,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  },
  "27": {
    "inputs": {
      "guide_size": 512,
      "guide_size_for": true,
      "max_size": 1024,
      "seed": 0,
      "steps": 20,
      "cfg": 8,
      "sampler_name": "euler",
      "scheduler": "simple",
      "denoise": 0.5,
      "feather": 5,
      "noise_mask": true,
      "force_inpaint": true,
      "bbox_threshold": 0.5,
      "bbox_dilation": 10,
      "bbox_crop_factor": 3,
      "sam_detection_hint": "center-1",
      "sam_dilation": 0,
      "sam_threshold": 0.93,
      "sam_bbox_expansion": 0,
      "sam_mask_hint_threshold": 0.7,
      "sam_mask_hint_use_negative": "False",
      "drop_size": 10,
      "wildcard": "",
      "cycle": 1,
      "inpaint_model": false,
      "noise_mask_feather": 20,
      "tiled_encode": false,
      "tiled_decode": false,
      "image": [
        "7",
        0
      ],
      "model": [
        "11",
        0
      ],
      "clip": [
        "10",
        1
      ],
      "vae": [
        "10",
        2
      ],
      "positive": [
        "29",
        0
      ],
      "negative": [
        "31",
        0
      ],
      "bbox_detector": [
        "33",
        0
      ]
    },
    "class_type": "FaceDetailer",
    "_meta": {
      "title": "FaceDetailer"
    }
  },
  "29": {
    "inputs": {
      "text": "",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "31": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, rating_questionable,source_photo, photorealistic, realistic, RAW photo, 8k uhd, dslr,1woman, adult, (korean or taiwanese ethnicity:1.2),(light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris, (single mole under right eye:1.35), (silver hoop earrings:1.1), (black velvet choker:1.1),(soft smile:1.2), (crinkly eyes:1.15), (blushing cheeks:1.1)",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "33": {
    "inputs": {
      "model_name": "bbox/face_yolov8m.pt"
    },
    "class_type": "UltralyticsDetectorProvider",
    "_meta": {
      "title": "UltralyticsDetectorProvider"
    }
  },
  "34": {
    "inputs": {
      "filename_prefix": "Aoi_fd1",
      "images": [
        "27",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  }
}', FALSE
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'aoi-IPAdapter9_fd1.json');

-- Aoi: api workflow api/aoi-IPAdapter9_fd5_strong_m_v0.33.0_1.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'aoi-IPAdapter9_fd5_strong_m_v0.33.0_1.json', '{
  "5": {
    "inputs": {
      "seed": 977481096307863,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "ddpm",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "37",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 1216,
      "height": 832,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "7": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "9": {
    "inputs": {
      "image": "aoi_ref_1.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ebaraPonyxlPonySDXL_v21.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "12": {
    "inputs": {
      "text": "(score_9, score_8_up:1.2), rating_questionable BREAK 1980s retro anime style, Haruhiko Mikimoto style, cinematic grain, shakerato BREAK 1girl,(pure black hair:1.3), long hair, blue eyes, (pink headphones worn on head:1.3), (leather choker:1.2) BREAK (pouting:1.3), (pouty lips:1.2), (annoyed expression:1.15), (averting gaze:1.1), (blushing cheeks:1.1) BREAK (wide_angle_lens:1.3), (perspective_distortion:1.2), (foreshortening:1.3), (high_angle:1.3), (sitting:1.3), (knees_down:1.4), (legs_closed:1.3), (leaning_forward:1.2), (from_below:1.3), (formal_skirt_lift:1.4), (crotch_focus:1.4), (panty_peek:1.4) BREAK (business_suit:1.1), black suit, (tight_pencil_skirt:1.2), white_dress_shirt, black_pantyhose BREAK bus stop, urban,dim light, cozy,cinematic grain, filmic",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "score_4, score_5, score_6, low quality, bad anatomy, text, watermark, (plastic_texture:1.1), (nipples:1.0), (pussy:1.0), (extra fingers:1.2), (other''s hand:1.4), (hand on shoulder:1.1), (hug:1.1), (interacting:1.1), (2multiple girls:1.1), (group:1.2), (headphones_around_neck:1.2), (headphones_on_shoulders:1.2), (sunglasses:1.1), (goggles:1.1), (eyewear on head:1.1), (visor:1.1), (head-mounted display:1.2), (glasses:1.1), (anime:1.3), 3d, render, blurry, lowres, bad hands, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA",
      "model_name": "buffalo_l"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  },
  "27": {
    "inputs": {
      "guide_size": 512,
      "guide_size_for": true,
      "max_size": 1024,
      "seed": 991476189003351,
      "steps": 20,
      "cfg": 8,
      "sampler_name": "euler",
      "scheduler": "simple",
      "denoise": 0.5,
      "feather": 5,
      "noise_mask": true,
      "force_inpaint": true,
      "bbox_threshold": 0.5,
      "bbox_dilation": 10,
      "bbox_crop_factor": 3,
      "sam_detection_hint": "center-1",
      "sam_dilation": 0,
      "sam_threshold": 0.93,
      "sam_bbox_expansion": 0,
      "sam_mask_hint_threshold": 0.7,
      "sam_mask_hint_use_negative": "False",
      "drop_size": 10,
      "wildcard": "",
      "cycle": 1,
      "inpaint_model": false,
      "noise_mask_feather": 20,
      "tiled_encode": false,
      "tiled_decode": false,
      "image": [
        "7",
        0
      ],
      "model": [
        "10",
        0
      ],
      "clip": [
        "10",
        1
      ],
      "vae": [
        "10",
        2
      ],
      "positive": [
        "29",
        0
      ],
      "negative": [
        "31",
        0
      ],
      "bbox_detector": [
        "33",
        0
      ]
    },
    "class_type": "FaceDetailer",
    "_meta": {
      "title": "FaceDetailer"
    }
  },
  "29": {
    "inputs": {
      "text": "(score_9, score_8_up:1.2), rating_questionable,1980s retro anime style, Haruhiko Mikimoto style, cinematic grain, shakerato,1girl,(pure black hair:1.3), long hair, blue eyes, (pink headphones worn on head:1.3), (leather choker:1.2),(pouting:1.3), (pouty lips:1.2), (annoyed expression:1.15), (averting gaze:1.1), (blushing cheeks:1.1)",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "31": {
    "inputs": {
      "text": "score_4, score_5, score_6, low quality, bad anatomy, text, watermark,(headphones_around_neck:1.2), (headphones_on_shoulders:1.2), (sunglasses:1.1), (goggles:1.1), (eyewear on head:1.1), (visor:1.1), (head-mounted display:1.2), (glasses:1.1), (anime:1.3), 3d, render, blurry, lowres, bad hands, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "33": {
    "inputs": {
      "model_name": "bbox/face_yolov8m.pt"
    },
    "class_type": "UltralyticsDetectorProvider",
    "_meta": {
      "title": "UltralyticsDetectorProvider"
    }
  },
  "34": {
    "inputs": {
      "filename_prefix": "Aoi_fd1",
      "images": [
        "51",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "37": {
    "inputs": {
      "weight": 1,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "10",
        0
      ],
      "ipadapter": [
        "45",
        0
      ],
      "image": [
        "40",
        0
      ],
      "clip_vision": [
        "46",
        0
      ]
    },
    "class_type": "IPAdapterAdvanced",
    "_meta": {
      "title": "IPAdapter Advanced"
    }
  },
  "38": {
    "inputs": {
      "interpolation": "LANCZOS",
      "crop_position": "top",
      "sharpening": 0,
      "image": [
        "9",
        0
      ]
    },
    "class_type": "PrepImageForClipVision",
    "_meta": {
      "title": "Prep Image For ClipVision"
    }
  },
  "40": {
    "inputs": {
      "method": "lanczos",
      "image_1": [
        "38",
        0
      ],
      "image_2": [
        "42",
        0
      ],
      "image_3": [
        "44",
        0
      ],
      "image_4": [
        "49",
        0
      ],
      "image_5": [
        "50",
        0
      ]
    },
    "class_type": "ImageBatchMultiple+",
    "_meta": {
      "title": "🔧 Images Batch Multiple"
    }
  },
  "41": {
    "inputs": {
      "image": "aoi_ref_2.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "42": {
    "inputs": {
      "interpolation": "LANCZOS",
      "crop_position": "top",
      "sharpening": 0,
      "image": [
        "41",
        0
      ]
    },
    "class_type": "PrepImageForClipVision",
    "_meta": {
      "title": "Prep Image For ClipVision"
    }
  },
  "43": {
    "inputs": {
      "image": "aoi_ref_3.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "44": {
    "inputs": {
      "interpolation": "LANCZOS",
      "crop_position": "top",
      "sharpening": 0,
      "image": [
        "43",
        0
      ]
    },
    "class_type": "PrepImageForClipVision",
    "_meta": {
      "title": "Prep Image For ClipVision"
    }
  },
  "45": {
    "inputs": {
      "ipadapter_file": "ip-adapter-plus_sdxl_vit-h.safetensors"
    },
    "class_type": "IPAdapterModelLoader",
    "_meta": {
      "title": "IPAdapter Model Loader"
    }
  },
  "46": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "47": {
    "inputs": {
      "image": "aoi_ref_4.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "48": {
    "inputs": {
      "image": "aoi_ref_5.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "49": {
    "inputs": {
      "interpolation": "LANCZOS",
      "crop_position": "top",
      "sharpening": 0,
      "image": [
        "47",
        0
      ]
    },
    "class_type": "PrepImageForClipVision",
    "_meta": {
      "title": "Prep Image For ClipVision"
    }
  },
  "50": {
    "inputs": {
      "interpolation": "LANCZOS",
      "crop_position": "top",
      "sharpening": 0,
      "image": [
        "48",
        0
      ]
    },
    "class_type": "PrepImageForClipVision",
    "_meta": {
      "title": "Prep Image For ClipVision"
    }
  },
  "51": {
    "inputs": {
      "color_space": "LAB",
      "factor": 1,
      "device": "auto",
      "batch_size": 0,
      "image": [
        "27",
        0
      ],
      "reference": [
        "52",
        0
      ]
    },
    "class_type": "ImageColorMatch+",
    "_meta": {
      "title": "🔧 Image Color Match"
    }
  },
  "52": {
    "inputs": {
      "image": "20260220_072854_0.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  }
}', TRUE
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'aoi-IPAdapter9_fd5_strong_m_v0.33.0_1.json');

-- Aoi: api workflow api/aoi-IPAdapter9a.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'aoi-IPAdapter9a.json', '{
  "5": {
    "inputs": {
      "seed": 785827035907660,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "ddpm",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 832,
      "height": 1216,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "7": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "8": {
    "inputs": {
      "filename_prefix": "aoi",
      "images": [
        "7",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "9": {
    "inputs": {
      "image": "20260220_192834_0.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ebaraPonyxlPonySDXL_v21.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 0.3,
      "weight_faceidv2": 3.5,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "9",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, rating_safe, 1girl, (pure black hair:1.3), long hair, blunt bangs, blue eyes, (pink headphones with a clean plastic headband:1.4), (smooth earpads), (wearing a sleek futuristic swimsuit style bodysuit:1.2), (slight see-through under starlight:1.2), (sitting with knees held to chest:1.4), hugging knees, barefoot, sitting against a large panoramic window of a spaceship, (view of deep space:1.3), colorful nebulae, shimmering stars, (backlit by distant stars:1.3), (long dramatic rim lighting:1.2), colorful light reflections on window, 1980s retro anime style, Haruhiko Mikimoto style, premium OVA aesthetic, city pop aesthetic, cinematic grain, masterpiece, high quality",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "score_4, score_5, score_6, (red hair, blue hair, multicolored hair, green hair:1.4), rating_explicit, nude, (chain headband:1.6), (metallic chain headband:1.5), metal texture, (accessory chain:1.3), long neck, bad anatomy, text, watermark, signature, source_pony, source_furry, (pantsu, lingerie:1.3)",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 1,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA",
      "model_name": "buffalo_l"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  }
}', FALSE
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'aoi-IPAdapter9a.json');

-- Aoi: api workflow api/aoi-IPAdapter9b.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'aoi-IPAdapter9b.json', '{
  "5": {
    "inputs": {
      "seed": 584339339365400,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "ddpm",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 1024,
      "height": 1024,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "9": {
    "inputs": {
      "image": "20260220_192834_0.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ebaraPonyxlPonySDXL_v21.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 0.3,
      "weight_faceidv2": 3.5,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "9",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "(score_9, score_8_up:1.2), rating_explicit BREAK 1980s retro anime style, Haruhiko Mikimoto style, cinematic grain, shakerato BREAK (pure black hair:1.3), long hair, blue eyes, (pink headphones worn on head:1.3), (leather choker:1.2) BREAK (back_view:1.4), (view_from_behind:1.4), (from_behind:1.4), (solo:1.2), (fingering:1.4), (hand_between_legs:1.3), (fingers_inside:1.5), (clancy_pussy:1.2), (pussy_juice:1.3), (spreading_pussy:1.4), (looking_down_at_own_crotch:1.2), (shame:1.4), (sobbing:1.1), trembling, (completely_undressed:1.4), (heavy_iron_collar:1.5), (clanking_chains:1.2), (nipples:1.1), (deep_blush:1.3), (sweat_on_skin:1.2), (shakerato:1.2) BREAK classic sailor school uniform, pleated skirt, red neckerchief, (thighhighs:1.2), no_bra, (nipples_visible_through_fabric:1.3), no_panties BREAK school corridor,candlelight, warm glow,lens flare, bright BREAK masterpiece, high quality",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "score_4, score_5, score_6, low quality, bad anatomy, text, watermark, (headphones_around_neck:1.2), (headphones_on_shoulders:1.2), (sunglasses:1.1), (goggles:1.1), (eyewear on head:1.1), (visor:1.1), (head-mounted display:1.2), (glasses:1.1), (plastic_texture:1.1), (penis:1.1), (dick:1.1), (cock:1.1), (worst quality:1.4), (low quality:1.4), lowres, bad anatomy, bad hands, text, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 1,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  },
  "26": {
    "inputs": {
      "upscale_method": "bicubic",
      "scale_by": 1.5,
      "samples": [
        "5",
        0
      ]
    },
    "class_type": "LatentUpscaleBy",
    "_meta": {
      "title": "潜在を拡大（指定サイズ）"
    }
  },
  "27": {
    "inputs": {
      "seed": 933476572286532,
      "steps": 20,
      "cfg": 8,
      "sampler_name": "ddpm",
      "scheduler": "karras",
      "denoise": 0.5,
      "model": [
        "10",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "26",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "28": {
    "inputs": {
      "samples": [
        "27",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "29": {
    "inputs": {
      "filename_prefix": "aoi_hires",
      "images": [
        "30",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "30": {
    "inputs": {
      "guide_size": 256,
      "guide_size_for": true,
      "max_size": 1024,
      "seed": 83540689494996,
      "steps": 20,
      "cfg": 8,
      "sampler_name": "euler",
      "scheduler": "simple",
      "denoise": 0.5,
      "feather": 5,
      "noise_mask": true,
      "force_inpaint": true,
      "bbox_threshold": 0.5,
      "bbox_dilation": 10,
      "bbox_crop_factor": 3,
      "sam_detection_hint": "center-1",
      "sam_dilation": 0,
      "sam_threshold": 0.93,
      "sam_bbox_expansion": 0,
      "sam_mask_hint_threshold": 0.7,
      "sam_mask_hint_use_negative": "False",
      "drop_size": 10,
      "wildcard": "",
      "cycle": 1,
      "inpaint_model": false,
      "noise_mask_feather": 20,
      "tiled_encode": false,
      "tiled_decode": false,
      "image": [
        "28",
        0
      ],
      "model": [
        "10",
        0
      ],
      "clip": [
        "10",
        1
      ],
      "vae": [
        "10",
        2
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "bbox_detector": [
        "31",
        0
      ]
    },
    "class_type": "FaceDetailer",
    "_meta": {
      "title": "FaceDetailer"
    }
  },
  "31": {
    "inputs": {
      "model_name": "bbox/hand_yolov8n.pt"
    },
    "class_type": "UltralyticsDetectorProvider",
    "_meta": {
      "title": "UltralyticsDetectorProvider"
    }
  },
  "32": {
    "inputs": {
      "filename_prefix": "aoi_hires_nonand",
      "images": [
        "28",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  }
}', FALSE
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'aoi-IPAdapter9b.json');

-- Aoi: api workflow api/aoi-IPAdapter9c.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'aoi-IPAdapter9c.json', '{
  "5": {
    "inputs": {
      "seed": 693462225834289,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "ddpm",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 1024,
      "height": 1024,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "9": {
    "inputs": {
      "image": "20260220_192834_0.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ebaraPonyxlPonySDXL_v21.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 0.3,
      "weight_faceidv2": 3.5,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "9",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "(score_9, score_8_up:1.2), rating_questionable BREAK 1980s retro anime style, Haruhiko Mikimoto style, cinematic grain, shakerato BREAK (pure black hair:1.3), long hair, blue eyes, (pink headphones worn on head:1.3), (leather choker:1.2) BREAK (leaning_forward:1.5), (bent_over:1.2), (downblouse:1.4), (view_into_shirt:1.3), (bra_visible:1.2), (dutch_angle:1.2), (tilted_frame:1.3), (cinematic_composition:1.2), (cowboy_shot:1.3), (foreshortening:1.3), (hands_on_knees:1.2), (looking_up:1.1), (gap_in_clothing:1.3), (upper_body_focus:1.1), (blush:1.2), (solo:1.3) BREAK white china dress, short china dress, (deep side slit:1.5), (silk embroidery:1.2), black_lace_bra BREAK bedroom, by window,spotlight, dramatic,watercolor effect, artistic BREAK masterpiece, high quality",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "score_4, score_5, score_6, low quality, bad anatomy, text, watermark, (headphones_around_neck:1.2), (headphones_on_shoulders:1.2), (sunglasses:1.1), (goggles:1.1), (eyewear on head:1.1), (visor:1.1), (head-mounted display:1.2), (glasses:1.1), (plastic_texture:1.1), (nipples:1.0), (pussy:1.0), (extra fingers:1.2), (other''s hand:1.4), (hand on shoulder:1.1), (hug:1.1), (interacting:1.1), (2multiple girls:1.1), (group:1.2), (worst quality:1.4), (low quality:1.4), lowres, bad anatomy, bad hands, text, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 1,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  },
  "26": {
    "inputs": {
      "upscale_method": "bicubic",
      "scale_by": 1.5,
      "samples": [
        "5",
        0
      ]
    },
    "class_type": "LatentUpscaleBy",
    "_meta": {
      "title": "潜在を拡大（指定サイズ）"
    }
  },
  "27": {
    "inputs": {
      "seed": 532850732246536,
      "steps": 20,
      "cfg": 8,
      "sampler_name": "ddpm",
      "scheduler": "karras",
      "denoise": 0.5,
      "model": [
        "10",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "26",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "28": {
    "inputs": {
      "samples": [
        "27",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "29": {
    "inputs": {
      "filename_prefix": "aoi_hires",
      "images": [
        "30",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "30": {
    "inputs": {
      "guide_size": 256,
      "guide_size_for": true,
      "max_size": 1024,
      "seed": 888124059634633,
      "steps": 20,
      "cfg": 8,
      "sampler_name": "euler",
      "scheduler": "simple",
      "denoise": 0.5,
      "feather": 5,
      "noise_mask": true,
      "force_inpaint": true,
      "bbox_threshold": 0.5,
      "bbox_dilation": 10,
      "bbox_crop_factor": 3,
      "sam_detection_hint": "center-1",
      "sam_dilation": 0,
      "sam_threshold": 0.93,
      "sam_bbox_expansion": 0,
      "sam_mask_hint_threshold": 0.7,
      "sam_mask_hint_use_negative": "False",
      "drop_size": 10,
      "wildcard": "",
      "cycle": 1,
      "inpaint_model": false,
      "noise_mask_feather": 20,
      "tiled_encode": false,
      "tiled_decode": false,
      "image": [
        "28",
        0
      ],
      "model": [
        "10",
        0
      ],
      "clip": [
        "10",
        1
      ],
      "vae": [
        "10",
        2
      ],
      "positive": [
        "35",
        0
      ],
      "negative": [
        "36",
        0
      ],
      "bbox_detector": [
        "31",
        0
      ]
    },
    "class_type": "FaceDetailer",
    "_meta": {
      "title": "FaceDetailer"
    }
  },
  "31": {
    "inputs": {
      "model_name": "bbox/hand_yolov8n.pt"
    },
    "class_type": "UltralyticsDetectorProvider",
    "_meta": {
      "title": "UltralyticsDetectorProvider"
    }
  },
  "33": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "34": {
    "inputs": {
      "filename_prefix": "aoi_no_hirex",
      "images": [
        "33",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "35": {
    "inputs": {
      "text": "5 fingers, perfect hands, clear fingers, detailed hands",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "36": {
    "inputs": {
      "text": "6 fingers, extra fingers, mutated hands, deformed fingers, missing fingers, bad anatomy",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  }
}', FALSE
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'aoi-IPAdapter9c.json');

-- Aoi: template workflow templates/workflow_args.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'template', 'workflow_args.json', '{
    "modifications": [
        {
            "node_id": "12",
            "condition": {
                "class_type": "CLIPTextEncode"
            },
            "modifications": {
                "inputs": {
                "text": "${positive_prompt}"
                }
            }
        },
        {
            "node_id": "13",
            "condition": {
                "class_type": "CLIPTextEncode"
            },
            "modifications": {
                "inputs": {
                "text": "${negative_prompt}"
                }
            }
        },
        {
            "node_id": "6",
            "condition": {
                "class_type": "EmptyLatentImage"
            },
            "modifications": {
                "inputs": {
                "width": "${image_width}",
                "height": "${image_height}",
                "batch_size": "${batch_size}"
                }
            }
        },
        {
            "node_id": "5",
            "condition": {
                "class_type": "KSampler"
            },
            "modifications": {
                "inputs": {
                "seed": "${random_seed}"
                }
            }
        },
        {
            "node_id": "29",
            "condition": {
                "class_type": "CLIPTextEncode"
            },
            "modifications": {
                "inputs": {
                    "text": "${face_detailer_positive_prompt}"
                }
            }
        },
        {
            "node_id": "31",
            "condition": {
                "class_type": "CLIPTextEncode"
            },
            "modifications": {
                "inputs": {
                    "text": "${face_detailer_negative_prompt}"
                }
            }
        }
    ]
}
', FALSE
FROM personyx.personas p
WHERE p.name = 'Aoi'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'template' AND w.workflow_name = 'workflow_args.json');

-- Lotta: character specification
INSERT INTO personyx.persona_character_specs (persona_id, name, target_model, is_default, config_json)
SELECT p.id, 'Lotta', 'PonyRealism', TRUE, '{
    "name": "Lotta",
    "target_model": "PonyRealism",
    "rating": {
        "safe": "rating_safe",
        "questionable": "rating_questionable",
        "explicit": "rating_explicit"
    },
    "config_paths": {
        "workflow_path": "configs/personas/Lotta/workflows/api/lotta-IPAdapter9_three_src_fd5_strongm_v_0.33.0_2.json",
        "mod_config": "configs/personas/Lotta/workflows/templates/workflow_args.json",
        "faceid_reference_images_conf": "configs/personas/Lotta/assets/faceid_reference_images.json",
        "camera_conf": "configs/personas/Lotta/assets/camera.json",
        "environment_conf": "configs/personas/Lotta/assets/environments.json",
        "expression_conf": "configs/personas/Lotta/assets/expressions.json",
        "wardrobe_conf": "configs/personas/Lotta/assets/wardrobe.json",
        "scene_conf": "configs/personas/Lotta/assets/scene.json"
    },
    "base_score_tags": "score_9, score_8_up, score_7_up",
    "base_style": "realistic photo",
    "base_identity_tags": "1woman, asian, (taiwanese ethnicity:1.25)",
    "body_parts": {
        "hair": ["(light brown hair:1.1)", "long hair", "(straight bangs:1.25)"],
        "eyes": ["brown eyes", "detailed iris"],
        "beauty mark": ["(single mole under right eye:1.35)"],
        "accesories": {
            "head": ["(silver hoop earrings:1.1)"],
            "neck": ["(black velvet choker:1.1)"]
        }
    },
    "negative_holy_grail": "score_4, score_3, score_2, score_1, worst quality, low quality, 3d render, cgi, illustration, smooth plastic skin, (worst quality, low quality:1.4), bad anatomy, text, logo, watermark, oversaturated colors",
    "negative_base": "(two people:1.45), (multiple people:1.4), (2people:1.45), (plastic skin:1.2), plastic_texture, lens_flare_artifact, (anime:1.3), 3d, render, blurry, lowres, bad hands, error, blurry",
    "negative_face": "(grimace:1.2), (bad teeth:1.3), (crooked teeth:1.2), (scary smile:1.2), (multiple moles:1.4), (freckles:1.4)",
    "innerwear_thresholds": {
        "1": 0,
        "2": 20,
        "3": 85,
        "4": 100
    },
    "negative_logic": {
        "items": [
            {
                "id": "neg_base_defense",
                "description": "全レベル共通：低品質・写実性を損なうアーティファクトを排除",
                "tags": "(plastic texture:1.2), (cartoon:1.3), (oversharpen:1.2), (unnatural skin tone:1.3), (lens artifact:1.2), (bad anatomy:1.3), (extra fingers:1.4), (deformed limbs:1.3)",
                "min_lv": 1, "max_lv": 5, "weight": 1.0
            },
            {
                "id": "neg_lv3_borderline",
                "description": "Lv1-3専用：写実表現の範囲で過度な露出や器官の直接描写を防ぐ",
                "tags": "(explicit nipples:1.0), (explicit genitalia:1.0), (graphic sexual content:1.2)",
                "min_lv": 1, "max_lv": 3, "weight": 1.2
            },
            {
                "id": "neg_lv4_reinforced",
                "description": "Lv4以上：画風崩壊を招く過度な表現を拒否",
                "tags": "(penis:1.1), (dick:1.1), (cock:1.1), (unrealistic proportions:1.2)",
                "min_lv": 4, "max_lv": 5, "weight": 1.0
            }
        ]
    }
}
'
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_character_specs s WHERE s.persona_id = p.id AND s.name = 'Lotta');

-- Lotta: camera asset
INSERT INTO personyx.persona_assets (persona_id, asset_type, asset_key, payload)
SELECT p.id, 'camera', 'default', '{
    "target_model": "PonyRealism",
    "camera_angles": [
        {
            "id": "80s_dramatic_slant",
            "name": "斜め構図（ダッチアングル）",
            "suggested_resolution": { "width": 1024, "height" : 1024 },
            "description": "心理的な揺らぎやドラマチックな転換点を示す斜め構図。写実表現ではライティングと被写界深度で自然に演出",
            "tags": "(dutch angle:1.1), (tilted frame:1.1), (cinematic composition:1.2), natural lighting",
            "vibe": "dramatic",
            "best_for": ["lv1", "lv2"]
        },
        {
            "id": "telephoto_intimacy",
            "name": "望遠レンズ・圧縮効果",
            "suggested_resolution": { "width": 832, "height" : 1216 },
            "description": "背景をやわらかくぼかして被写体の存在感と細部（髪・瞳・肌質）を際立たせる写実的クローズアップ",
            "tags": "(extreme close-up:1.4), (shallow depth of field:1.6), (bokeh:1.3), (telephoto lens:1.2), natural skin detail",
            "vibe": "intimate",
            "best_for": ["lv1", "lv2", "lv3"]
        },
        {
            "id": "wide_angle_distortion",
            "name": "広角レンズ・パース強調",
            "suggested_resolution": { "width": 1216, "height" : 832 },
            "description": "前景を強調して遠近感を作る。写実では過度な魚眼効果を避け、自然なパース調整を推奨",
            "tags": "(wide angle lens:1.2), (perspective distortion:1.1), (foreshortening:1.3), (mild fisheye:0.6), realistic perspective",
            "vibe": "dynamic",
            "best_for": ["lv2", "lv4"]
        },
        {
            "id": "low_angle_authority",
            "name": "ローアングル・煽り",
            "suggested_resolution": { "width": 768, "height" : 1344 },
            "description": "見上げる視点で被写体の威厳や脚線を強調。写実的ライティングで陰影をコントロール",
            "tags": "(from below:1.4), (low angle:1.3), (worm''s eye view:1.1), natural contrast",
            "vibe": "powerful",
            "best_for": ["lv2", "lv3", "lv4"]
        },
        {
            "id": "high_angle_fragility",
            "name": "ハイアングル・俯瞰",
            "suggested_resolution": { "width": 1216, "height" : 832 },
            "description": "見下ろす視点で被写体の脆弱さを表現。広がる環境と自然光のバランスを重視",
            "tags": "(from above:1.4), (high angle:1.3), (bird''s eye view:1.1), atmospheric lighting",
            "vibe": "observational",
            "best_for": ["lv1", "lv2", "lv3", "lv4"]
        },
        {
            "id": "over_the_shoulder_voyer",
            "name": "肩越し・覗き見視点",
            "description": "第三者の視点を示唆する構図。写実表現では被写界深度と自然な遮蔽で没入感を作る",
            "suggested_resolution": { "width": 1216, "height" : 832 },
            "tags": "(over the shoulder:1.3), (point of view:1.1), (partial obscured view:1.1), subtle depth",
            "vibe": "storytelling",
            "best_for": ["lv1", "lv4"]
        },
        {
            "id": "back_view_allure",
            "name": "背面視点・バックビュー",
            "suggested_resolution": { "width": 1024, "height" : 1024 },
            "description": "背中やヒップのラインを自然光と質感で強調する写実的なバックビュー",
            "tags": "(back view:1.3), (view from behind:1.3), (from behind:1.3), (solo:1.1), natural lighting, detailed skin texture",
            "vibe": "mysterious",
            "best_for": ["lv1", "lv2", "lv3", "lv4"]
        }
    ]
}
'
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_assets a WHERE a.persona_id = p.id AND a.asset_type = 'camera' AND a.asset_key = 'default');

-- Lotta: environments asset
INSERT INTO personyx.persona_assets (persona_id, asset_type, asset_key, payload)
SELECT p.id, 'environments', 'default', '{
    "target_model": "PonyRealism",
    "locations": [
        {
            "id": "classroom_desk",
            "tags": "classroom, sitting at desk, natural lighting, realistic fabric",
            "description": "教室の机に座っている情景（自然光と現実的な質感を重視）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "classroom_window",
            "tags": "classroom, near window, sunlight filtering, window reflection",
            "description": "窓際の教室の情景（差し込む光の表現を重視）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "library_bookshelf",
            "tags": "library, by bookshelf, warm indoor light, detailed wood texture",
            "description": "本棚のある図書館の情景（木目や紙の質感を強調）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "library_reading_area",
            "tags": "library, reading area, soft natural light, cozy",
            "description": "読書エリアのある図書館の情景（柔らかな自然光で被写体を包む）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "cafe_table",
            "tags": "cafe, at table, ambient interior light, cup reflection",
            "description": "カフェのテーブル席の情景（照明と反射の扱いを重視）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "school_corridor",
            "tags": "school corridor, natural window light, polished floor reflection",
            "description": "学校の廊下の情景（光の屈折や床の反射を意識）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "school_rooftop",
            "tags": "school rooftop, open sky, wind motion, atmospheric haze",
            "description": "学校の屋上の情景（空気感と風の表現を重視）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "city_street",
            "tags": "city street, urban, wet pavement reflection, ambient neon",
            "description": "都市の通りの情景（路面や背景の光源を写実的に扱う）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit", "gym_uniform"]
        },
        {
            "id": "park_bench",
            "tags": "park, on bench, dappled sunlight, natural foliage",
            "description": "公園のベンチに座っている情景（木漏れ日と葉のテクスチャを重視）",
            "not_compatible_outfits": ["lingerie_only", "bunny_suit"]
        },
        {
            "id": "beach_shore",
            "tags": "beach, seashore, wet sand reflection, natural ocean lighting",
            "description": "海岸の情景（海面反射と湿った質感の再現を重視）",
            "not_compatible_outfits": ["classic_sailor", "blazer_style", "gym_uniform", "oversized_hoodie", "office_lady", "miko_outfit", "yukata"]
        },
        {
            "id": "mountain_path",
            "tags": "mountain path, forest, uneven terrain, natural shade",
            "description": "山道の情景（地形と影の入り方、空気遠近を重視）",
            "not_compatible_outfits": ["classic_sailor", "blazer_style", "office_lady", "evening_dress", "turtleneck", "bunny_suit", "lingerie_only", "nurse_outfit", "china_dress"]
        },
        {
            "id": "japanese_garden",
            "tags": "japanese garden, traditional, stone path, moss detail",
            "description": "日本庭園の情景（苔や石材の細部表現を重視）",
            "not_compatible_outfits": ["swimsuit_80s", "cyberpunk_outfits"]
        },
        {
            "id": "amusement_park",
            "tags": "amusement park, rides, motion blur for movement, evening lights",
            "description": "遊園地の情景（動的要素と光の点描を写実的に表現）",
            "not_compatible_outfits": ["lingerie_only", "bunny_suit"]
        },
        {
            "id": "shopping_mall",
            "tags": "shopping mall, indoors, skylight diffusion, human scale",
            "description": "ショッピングモールの情景（人工光と自然光の混在を扱う）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "train_station",
            "tags": "train station, platform, motion blur, reflective floor",
            "description": "駅のプラットフォームの情景（動きと反射の扱いを重視）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "bus_stop",
            "tags": "bus stop, urban, ambient shadow",
            "description": "バス停の情景（都市光による色被りや影の表現を重視）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "aquarium",
            "tags": "aquarium, underwater exhibits, soft blue tint, caustics",
            "description": "水族館の情景（水の屈折や光の揺らぎを写実的に表現）",
            "not_compatible_outfits": ["lingerie_only", "bunny_suit"]
        },
        {
            "id": "concert_hall",
            "tags": "concert hall, stage, spotlight, auditorium depth",
            "description": "コンサートホールの情景（スポットと空間の奥行きを重視）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "art_museum",
            "tags": "art museum, gallery, diffuse museum light, wall texture",
            "description": "美術館の情景（展示物と空間の調和を重視）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "apartment_balcony",
            "tags": "apartment, balcony, cityscape view, railing detail",
            "description": "アパートのバルコニーからの都市の情景（遠景の大気表現を重視）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "bedroom_window",
            "tags": "bedroom, by window, warm_interior light, fabric detail",
            "description": "寝室の窓際の情景（布や肌の質感を写実的に扱う）",
            "not_compatible_outfits": ["swimsuit_80s"]
        },
        {
            "id": "kitchen_counter",
            "tags": "kitchen, at counter, reflective surfaces, utensil detail",
            "description": "キッチンのカウンターの情景（光の反射と素材感を重視）",
            "not_compatible_outfits": ["classic_sailor", "blazer_style", "office_lady", "evening_dress", "miko_outfit", "yukata", "china_dress"]
        },
        {
            "id": "shrine_grounds",
            "tags": "shrine, peaceful grounds, stone texture, moss detail",
            "description": "神社の境内、穏やかな情景（素材の経年変化を表現）",
            "not_compatible_outfits": ["swimsuit_80s", "cyberpunk_outfits"]
        },
        {
            "id": "festival_night",
            "tags": "japanese festival, night, paper lantern glow, crowd bokeh",
            "description": "日本の祭りの夜の情景（提灯の光と群衆の奥行きを写実的に）",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "sci_fi_lab",
            "tags": "sci-fi laboratory, futuristic, specular surfaces, soft blue ambient",
            "description": "SF研究所、未来的な情景（ライティングと材質の冷たさを強調）",
            "not_compatible_outfits": ["classic_sailor", "blazer_style", "gym_uniform", "office_lady", "miko_outfit", "yukata", "casual_outfits"]
        },
        {
            "id": "cyberpunk_alley",
            "tags": "cyberpunk alley, neon signs, wet reflections, atmospheric haze",
            "description": "サイバーパンクな路地裏、ネオンサインの情景（濡れた路面と光の反射を重視）",
            "not_compatible_outfits": ["classic_sailor", "blazer_style", "gym_uniform", "office_lady", "miko_outfit", "yukata", "casual_outfits"]
        },
        {
            "id": "underwater_ruins",
            "tags": "underwater ruins, ancient technology, caustics, suspended particles",
            "description": "水中遺跡、古代技術の情景（水中の光と粒子の表現を重視）",
            "not_compatible_outfits": ["classic_sailor", "blazer_style", "gym_uniform", "oversized_hoodie", "office_lady", "sundress", "tracksuit", "miko_outfit", "yukata", "off_shoulder", "evening_dress", "turtleneck", "china_dress"]
        },
        {
            "id": "space_station",
            "tags": "space station, zero gravity, controlled lighting, metallic surfaces",
            "description": "宇宙ステーション、無重力の情景（人工光と金属の質感を重視）",
            "not_compatible_outfits": ["classic_sailor", "blazer_style", "gym_uniform", "oversized_hoodie", "office_lady", "sundress", "tracksuit", "miko_outfit", "yukata", "off_shoulder", "evening_dress", "turtleneck", "china_dress", "swimsuit_80s"]
        },
        {
            "id": "fantasy_forest",
            "tags": "fantasy forest, soft_magical glow, volumetric light",
            "description": "幻想的な森、魔法の輝きの情景（写実的な空気感と光の層を重視）",
            "not_compatible_outfits": ["classic_sailor", "blazer_style", "gym_uniform", "oversized_hoodie", "office_lady", "sundress", "tracksuit", "bunny_suit", "lingerie_only", "nurse_outfit", "china_dress", "swimsuit_80s", "sci_fi_lab", "cyberpunk_alley", "underwater_ruins", "space_station"]
        },
        {
            "id": "hotel_suite_night",
            "tags": "luxury hotel suite, night view, large bed, dim warm lighting, fabric detail",
            "description": "高級ホテルのスイートルーム。夜景の見える親密な室内空間。",
            "not_compatible_outfits": ["gym_uniform", "school_uniform", "classic_sailor", "tracksuit"]
        },
        {
            "id": "glass_shower_room",
            "tags": "steamy glass shower room, wet_floor, bathroom, realistic water droplets",
            "description": "湯気のこもったガラス張りのシャワールーム。濡れた肌や透け感の演出に適した場所。",
            "not_compatible_outfits": ["blazer_style", "office_lady", "miko_outfit", "yukata", "evening_dress", "turtleneck", "oversized_hoodie"]
        },
        {
            "id": "private_sauna",
            "tags": "private sauna, wooden interior, dim warm lighting, steam, skin sheen",
            "description": "プライベートサウナ。木製の室内と薄暗い照明、汗ばんだ肌の質感を強調する空間。",
            "not_compatible_outfits": ["classic_sailor", "blazer_style", "office_lady", "evening_dress", "turtleneck", "china_dress", "school_uniform"]
        },
        {
            "id": "infirmary_afternoon",
            "tags": "school infirmary, medical office, curtained bed, afternoon sunlight, soft shadows",
            "description": "放課後の保健室。カーテンで仕切られたベッドなど、静かな雰囲気を演出。",
            "not_compatible_outfits": ["evening_dress", "china_dress", "cyberpunk_outfits", "bunny_suit"]
        },
        {
            "id": "night_poolside",
            "tags": "swimming pool, poolside, night, moonlit_water, specular reflections",
            "description": "夜のプールサイド。月明かりと水面の反射が美しい静かな屋外空間。",
            "not_compatible_outfits": ["office_lady", "turtleneck", "miko_outfit", "yukata", "evening_dress"]
        },
        {
            "id": "elevator_interior",
            "tags": "inside elevator, mirrored walls, closed space, reflective surfaces",
            "description": "エレベーター内。鏡張りの壁と密閉された空間による緊張感。",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "bunny_suit"]
        },
        {
            "id": "cinema_back_row",
            "tags": "movie theater, back row seats, dark, cinematic lighting, grain control",
            "description": "映画館の最後列。暗闇の中で秘め事のニュアンスを与える場所。",
            "not_compatible_outfits": ["swimsuit_80s", "lingerie_only", "gym_uniform", "bunny_suit"]
        },
        {
            "id": "photo_studio",
            "tags": "photography studio, lighting equipment, softbox, backdrop, controlled lighting",
            "description": "撮影スタジオ。照明機材に囲まれた人工的な空間。",
            "not_compatible_outfits": []
        },
        {
            "id": "abandoned_factory",
            "tags": "abandoned factory, ruins, rusty pipes, concrete walls, dramatic shadows, texture detail",
            "description": "無人の廃工場。冷たいコンクリートと柔らかな肌のコントラストを強調するロケーション。",
            "not_compatible_outfits": ["office_lady", "sundress", "evening_dress"]
        },
        {
            "id": "traditional_washitsu",
            "tags": "japanese room, tatami, futon, paper lantern, sliding doors, warm tone",
            "description": "伝統的な和室。畳と行灯の光が和の情緒を演出する。",
            "not_compatible_outfits": ["cyberpunk_outfits", "sci_fi_lab", "swimsuit_80s"]
        },
        {
            "id": "throne_room",
            "tags": "throne room, royal palace, grand architecture, red carpet, volumetric light",
            "description": "豪華な玉座の間。高貴な雰囲気を写実的に表現する空間。",
            "not_compatible_outfits": ["gym_uniform", "tracksuit", "oversized_hoodie", "casual_outfits"]
        },
        {
            "id": "dungeon_cell",
            "tags": "prison cell, dungeon, stone walls, iron bars, shackles, cold tone",
            "description": "地下牢。石壁と鉄格子、拘束具などが似合うダークなシチュエーション。",
            "not_compatible_outfits": ["office_lady", "sundress", "business_suit"]
        },
        {
            "id": "ritual_altar",
            "tags": "ritual altar, magic circle, glowing runes, moody light",
            "description": "儀式の祭壇。神秘的で重厚な空間。",
            "not_compatible_outfits": ["office_lady", "business_suit", "gym_uniform", "tracksuit"]
        }
    ],
    "lightings": [
        {"id": "golden_hour", "tags": "golden hour lighting, warm glow, long shadows", "description": "夕焼け時の柔らかい光", "not_compatible_outfits": []},
        {"id": "soft_natural", "tags": "soft natural light, diffuse light", "description": "穏やかな自然光", "not_compatible_outfits": []},
        {"id": "dim_light", "tags": "dim light, cozy, warm tone", "description": "薄暗く、心地よい光", "not_compatible_outfits": []},
        {"id": "backlighting", "tags": "backlighting, silhouette, rim light", "description": "逆光、シルエットを強調する光", "not_compatible_outfits": []},
        {"id": "neon_glow", "tags": "neon glow, vibrant, colored reflection", "description": "ネオンの光、鮮やかな雰囲気", "not_compatible_outfits": ["classic_sailor", "miko_outfit"]},
        {"id": "spotlight", "tags": "spotlight, dramatic, high contrast", "description": "スポットライト、劇的な光", "not_compatible_outfits": []},
        {"id": "moonlight", "tags": "moonlight, serene, cool tone", "description": "月明かり、静寂な雰囲気", "not_compatible_outfits": []},
        {"id": "sunlight_filtering", "tags": "sunlight filtering through, dappled light, volumetric rays", "description": "木漏れ日、差し込む柔らかな光", "not_compatible_outfits": []},
        {"id": "strobe_light", "tags": "strobe light, chaotic, high intensity", "description": "ストロボライト、混沌とした光", "not_compatible_outfits": ["classic_sailor", "miko_outfit", "yukata", "office_lady"]},
        {"id": "candlelight", "tags": "candlelight, warm glow, soft shadows", "description": "キャンドルの光、温かい輝き", "not_compatible_outfits": ["gym_uniform", "swimsuit_80s"]}
    ],
    "textures": [
        {"id": "cinematic_grain", "tags": "cinematic grain, filmic, subtle grain", "description": "映画のような粒状感、フィルム風", "not_compatible_outfits": []},
        {"id": "dust_particles", "tags": "dust particles, atmospheric haze, floating particles", "description": "舞い散る埃、雰囲気のある霞", "not_compatible_outfits": []},
        {"id": "bokeh_blur", "tags": "bokeh, soft focus, photorealistic bokeh", "description": "ボケ効果、柔らかな焦点", "not_compatible_outfits": []},
        {"id": "rain_drops", "tags": "rain drops on window, wet, realistic water droplets", "description": "窓の雨粒、濡れた質感", "not_compatible_outfits": ["swimsuit_80s", "beach_shore", "mountain_path"]},
        {"id": "steam_haze", "tags": "steam, hazy atmosphere, volumetric haze", "description": "湯気、霞んだ雰囲気", "not_compatible_outfits": ["beach_shore", "school_rooftop"]},
        {"id": "glitter", "tags": "glitter, sparkling, subtle speculars", "description": "きらめき、輝く表現", "not_compatible_outfits": ["classic_sailor", "gym_uniform", "office_lady"]},
        {"id": "subtle_smoke", "tags": "subtle smoke, mysterious, volumetric smoke", "description": "かすかな煙、神秘的な雰囲気", "not_compatible_outfits": []},
        {"id": "lens_flare", "tags": "lens flare, bright, optical artifact", "description": "レンズフレア、明るい光の反射", "not_compatible_outfits": []},
        {"id": "pixel_art", "tags": "pixel art style, retro game aesthetic", "description": "ピクセルアート調、レトロゲームの美学", "not_compatible_outfits": ["classic_sailor", "blazer_style", "gym_uniform", "office_lady", "miko_outfit", "yukata", "off_shoulder", "sundress", "tracksuit", "evening_dress", "turtleneck", "bunny_suit", "lingerie_only", "nurse_outfit", "china_dress", "swimsuit_80s"]}
    ]
}
'
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_assets a WHERE a.persona_id = p.id AND a.asset_type = 'environments' AND a.asset_key = 'default');

-- Lotta: expressions asset
INSERT INTO personyx.persona_assets (persona_id, asset_type, asset_key, payload)
SELECT p.id, 'expressions', 'default', '{
    "expressions": [
        {
            "id": "smile",
            "name": "笑顔",
            "tags": "(soft smile:1.2), (crinkly eyes:1.15), (blushing cheeks:1.1)",
            "min_lv": 1,
            "max_lv": 3,
            "weight": 1.2
        },
        {
            "id": "pouting",
            "name": "膨れっ面",
            "tags": "(pouting:1.3), (pouty lips:1.2), (annoyed expression:1.15), (averting gaze:1.1), (blushing cheeks:1.1)",
            "min_lv": 1,
            "max_lv": 3,
            "weight": 0.8
        },
        {
            "id": "startled",
            "name": "驚き",
            "tags": "(startled expression:1.25), (wide eyes:1.15), (gasping:1.2), surprised look, (looking at viewer:1.15)",
            "min_lv": 1,
            "max_lv": 3,
            "weight": 1.1
        },
        {
            "id": "smirk",
            "name": "挑発",
            "tags": "(smirk:1.35), (seductive smile:1.15), (confident expression:1.2), (narrowed eyes:1.1)",
            "min_lv": 1,
            "max_lv": 3,
            "weight": 0.8
        },
        {
            "id": "melancholic",
            "name": "哀愁",
            "tags": "(melancholic expression:1.25), (wistful look:1.2), (pensive:1.1), (parted lips:1.1), (averting gaze:1.15)",
            "min_lv": 1,
            "max_lv": 3,
            "weight": 0.8
        },
        {
            "id": "bedroom eyes",
            "name": "恍惚",
            "tags": "(bedroom eyes:1.3), (heavy eyelids:1.2), (parted lips:1.15), (expression of pleasure:1.2), (slight blush:1.1)",
            "min_lv": 3,
            "max_lv": 4,
            "weight": 1.0
        },
        {
            "id": "shame",
            "name": "屈辱",
            "tags": "(frown:1.3), (looking down and away:1.25), (tears on cheek:1.25), (parted lips:1.2), (gasping for air:1.3)",
            "min_lv": 4,
            "max_lv": 4,
            "weight": 1.0
        }
    ]
}'
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_assets a WHERE a.persona_id = p.id AND a.asset_type = 'expressions' AND a.asset_key = 'default');

-- Lotta: scene asset
INSERT INTO personyx.persona_assets (persona_id, asset_type, asset_key, payload)
SELECT p.id, 'scene', 'default', '{
    "_scene_group_catalog": {
        "bottom_exposure": "下半身・下着露出系",
        "top_exposure": "上半身・胸元露出系",
        "innerwear_exposure": "下着露出全般",
        "clothing_destruction": "衣装破壊系",
        "wind_effect": "風による衣装変化",
        "high_risk": "特定レベル以上の強い表現",
        "intimacy": "近距離・親密な構図",
        "restraint": "拘束・強制姿勢を含む構図",
        "sexual_activity": "性的行為・道具を含む構図",
        "transparency": "濡れ・透け・布越しの描写"
    },
    "scene_logic": [
        {
            "id": "lv1_window_side_dreaming",
            "description": "窓際での物思い。{camera}により、外を眺める横顔や室内からの引きの構図が可能",
            "tags": "(looking out window:1.5), (looking afar:1.3), (profile:1.2), (from side:1.1), {camera}, sitting at desk, (head tilt:1.1), (arm on desk:1.1), (sunlight filtering through:1.2), (backlighting:1.1)",
            "min_lv": 1, "max_lv": 2, "weight": 4.0,
            "destructible_scene": false,
            "inner_inclusion": {"top": false, "bottom": false}
        },
        {
            "id": "lv1_reading_immersion",
            "description": "読書に没頭。カメラアングルで視線や集中を演出",
            "tags": "(reading book:1.4), (holding open book:1.3), (looking down at book:1.3), sitting at desk, {camera}, leaning forward, (focus on hand:1.1), (hair falling over face:1.3), soft expression",
            "min_lv": 1, "max_lv": 2, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {"top": false, "bottom": false}
        },
        {
            "id": "lv1_afterschool_napping",
            "description": "居眠り。机に寄りかかる柔らかな瞬間を自然光で捉える",
            "tags": "(sleeping at desk:1.5), (slumped over desk:1.5), {camera}, closed eyes, peaceful expression, (soft diffused light:1.2)",
            "min_lv": 1, "max_lv": 2, "weight": 1.0,
            "destructible_scene": false,
            "inner_inclusion": {"top": false, "bottom": false}
        },
        {
            "id": "lv1_listening_music",
            "description": "ヘッドフォンで音楽に没入する瞬間。細部の質感を重視",
            "tags": "(listening to music:1.4), (closed eyes:1.4), (hands on headphones:1.4), sitting, {camera}, cinematic vibe",
            "min_lv": 1, "max_lv": 2, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {"top": false, "bottom": false}
        },
        {
            "id": "lv1_tucking_hair_behind_ear",
            "description": "髪を耳にかける自然な仕草。首筋や指先の細部表現を重視",
            "tags": "{camera}, (tucking hair behind ear:1.4), (hand to head:1.2), (solo:1.2)",
            "min_lv": 1, "max_lv": 2, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {"top": false, "bottom": false}
        },
        {
            "id": "lv1_walking_corridor",
            "description": "廊下を歩く。{camera}で(wide_shot)なら放課後の静寂、(telephoto)なら彼女を追うような視点に",
            "tags": "(walking in school corridor:1.3), (walking away:1.2), {camera}, (cowboy shot:1.3), (hair fluttering:1.4), (backlighting:1.2), (looking sideways:1.1), (detailed face:1.3)",
            "min_lv": 1, "max_lv": 2, "weight": 1.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            } 
        },
        {
            "id": "lv1_walking_path",
            "description": "場所を問わず歩くシーン。{location}との組み合わせで、放課後、オフィス街、廃墟などに対応可能。",
            "tags": "(walking:1.3), (walking away:1.2), (step forward:1.1), {camera}, (cowboy shot:1.3), (hair fluttering:1.4), (backlighting:1.2), (looking sideways:1.1), (detailed face:1.3)",
            "min_lv": 1, "max_lv": 2, "weight": 1.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            }
        },
        {
            "id": "lv2_shy_glance",
            "description": "照れ隠しの一瞬。表情の微妙な変化を丁寧に描写",
            "tags": "{camera}, (looking away:1.3), (shy glance:1.4), (playing with hair:1.2), (blushing:1.4), (tucking hair behind ear:1.3), standing, (delicate fingers:1.2)",
            "min_lv": 2, "max_lv": 3, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {"top": false, "bottom": false}
        },
        {
            "id": "lv2_staring_contest",
            "description": "凝視。{camera}を(low_angle)にすれば圧倒的な存在感、(telephoto)なら彼女の瞳の虹彩まで描画",
            "tags": "{camera}, (staring:1.4), (looking at viewer:1.5), (deep blush:1.2), (parted lips:0.9), (intense eyes:1.3), standing, (unwavering gaze:1.2)",
            "min_lv": 2, "max_lv": 3, "weight": 1.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            }
        },
        {
            "id": "lv2_leaning_on_shoulder",
            "scene_groups": ["intimacy"],
            "description": "無防備な近接。{camera}を(over_the_shoulder)にすれば、彼女の体温を感じるような没入感のある構図に",
            "tags": "{cammera}, (first-person view:1.3), (face-to-face closeness:1.35), (looking back at the camera:1.25), (soft lighting:1.3), evening light, (heavy bokeh:1.4), (solo:1.3)",
            "min_lv": 2, "max_lv": 3, "weight": 1.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": false
            } 
        },
        {
            "id": "lv2_whisper_close",
            "scene_groups": ["intimacy"],
            "description": "近くで囁くような距離感。口元の質感と息づかいを示唆する表現",
            "tags": "{camera}, (leaning towards viewer:1.4), (looking at viewer:1.2), (whispering:1.1), (blushing:1.3), (parted lips:1.1), soft expression, (hand near mouth:1.2), (delicate fingers:1.1)",
            "min_lv": 2, "max_lv": 3, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {"top": false, "bottom": false}
        },
        {
            "id": "lv2_fixing_hair_tie",
            "description": "髪を結う所作。動きに伴う布や髪の自然な反応を重視",
            "tags": "{camera}, (arms up:1.4), (fixing hair:1.3), (exposed neck:1.3), (exposed armpits:1.2), (blushing:1.1), standing, (ponytail:1.1), (stretched fabric:1.2)",
            "min_lv": 2, "max_lv": 3, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {"top": false, "bottom": false}
        },
        {
            "id": "lv2_leaning_closer_curiosity",
            "description": "視線を下に向けて覗き込むような構図。表情と距離感で緊張感を作る",
            "tags": "{camera}, (leaning forward:1.35), (looking down at the camera:1.25), (eyes cast downward:1.2), (view into shirt:1.25), (bra visible:1.3), (curious expression:1.2), (long hair falling forward framing her face:1.4), (foreshortening:1.3), (shallow depth of field:1.4), (deep blush:1.2), (watery eyes:1.1)",
            "min_lv": 2, "max_lv": 3, "weight": 1.5,
            "destructible_scene": false,
            "inner_inclusion": {"top": false, "bottom": false}
        },
        {
            "id": "lv2_phys_cleavage_peek",
            "scene_groups": ["top_exposure", "innerwear_exposure"],
            "description": "衣服の隙間から生まれるラインの描写（PonyRealismでは質感重視）",
            "tags": "(leaning forward:1.35), (downblouse:1.4), (view into shirt:1.3), (bra visible:1.2), {camera}, (foreshortening:1.3), (gap in clothing:1.3), (upper body focus:1.2), (35mm photograph:1.25), (blush:1.2), (solo:1.3)",
            "min_lv": 2, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {"top": true, "bottom": false}
        },
        {
            "id": "lv2_fixing_uniform_button",
            "description": "ボタンを留める繊細な仕草。手元の描写を高精細に",
            "tags": "{camera}, (buttoning:1.5), (adjusting clothes:1.4), (fingers on button:1.4), (hands on own chest:1.4), (looking down:1.4), (waist up:1.3), (delicate fingers:1.3), (focused expression:1.2), (buttons:1.4), (front buttons:1.2), (no extra hands:1.5), (solo:1.3)",
            "min_lv": 2, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {"top": true, "bottom": false}
        },
        {
            "id": "lv2_leaning_against_railing",
            "scene_groups": ["bottom_exposure", "wind_effect"],
            "description": "手摺に寄りかかる穏やかな佇まい。遠景の空気感と光の質を重視",
            "tags": "(leaning on railing:1.3), (looking at horizon:1.3), {camera}, ({target_fabric_outer_bottom} flip:1.4), ({target_fabric_outer_bottom} wind:1.3), (wind blown hair:1.4), (distant cityscape:1.2), (sunset sky:1.3), (skylight:1.2), (peaceful moment:1.1)",
            "min_lv": 1, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {"top": false, "bottom": true}
        },
        {
            "id": "lv2_5_phys_sitting_gap",
            "scene_groups": ["bottom_exposure", "innerwear_exposure"],
            "description": "【着座の油断】無防備な足元",
            "tags": "{camera}, (sitting:1.2), (spread legs:1.1), ({target_fabric_outer_bottom} spread:1.3), (view from low angle:1.4), (panty visible:1.4)",
            "min_lv": 2, "max_lv": 3, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            }
        },
        {
            "id": "lv2_5_env_stair_climb",
            "scene_groups": ["bottom_exposure", "innerwear_exposure"],
            "description": "【階段の遠近法】高低差による露出",
            "tags": "(walking up stairs:1.2), from below, (upskirt:1.3), (cinematic angle:1.2), (leg focus:1.2), (panty visible:1.3)",
            "min_lv": 2, "max_lv": 3, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv2_5_phys_high_reach",
            "scene_groups": ["bottom_exposure", "top_exposure", "innerwear_exposure"],
            "description": "【背伸びと延伸】裾の限界",
            "tags": "(from below:1.5), (low angle:1.4), (standing on tiptoe:1.5), (heels up:1.4), (arching back:1.4), (arms stretched up:1.3), (interlocked fingers:1.2), (stretching:1.3), (looking up:1.2), (armpits:1.3), (ribs:1.1), ({target_fabric_outer_bottom} riding up:1.4), (panty focus:1.3), (crotch focus:1.2)",
            "min_lv": 2, "max_lv": 3, "weight": 1.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv2_5_phys_bending_peek",
            "scene_groups": ["bottom_exposure", "top_exposure", "innerwear_exposure"],
            "description": "【屈伸の死角】前傾姿勢",
            "tags": "(bending over:1.5), (leaning forward:1.4), (back three-quarter view:1.4), (diagonal view:1.2), (from side:1.1), (low angle:1.4), (from below:1.2), ({target_fabric_outer_bottom} lift:1.1), (upskirt:1.2), (panty visible:1.2), ({target_fabric_outer_bottom} gap:1.3), (embarrassed:1.2), (accidental:1.1), (looking at viewer:1.2), (looking down:1.1)",
            "min_lv": 2, "max_lv": 3, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv2_5_env_windy_front",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "wind_effect"],
            "description": "【前方・風の悪戯】自然な浮き上がり",
            "tags": "(from below:1.5), (low angle:1.4), (worm''s eye view:1.2), (looking up:1.3), (gale:1.35), (strong wind:1.4), (gust of wind:1.3), (skirt blowing up:1.45), (billowing {target_fabric_outer_bottom}:1.3), (hand on {target_fabric_outer_bottom}:1.25), (embarrassed:1.2), (wide eyes:1.2), (panty visible:1.3)",
            "min_lv": 2, "max_lv": 3, "weight": 1.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            },
            "suggested_resolution": { "width": 832, "height" : 1216 }
        },
        {
            "id": "lv2_5_env_windy_back",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "wind_effect"],
            "description": "【後方・風の悪戯】自然な浮き上がり",
            "tags": "(view from behind:1.5), (back view:1.4), (looking back:1.3), (low angle:1.4), (worm''s eye view:1.2), (wind blowing {target_fabric_outer_bottom}:1.4), ({target_fabric_outer_bottom} lift:1.3), (hand on {target_fabric_outer_bottom}:1.2), (embarrassed:1.2), (wide eyes:1.2), (panty visible:1.3)",
            "min_lv": 2, "max_lv": 3, "weight": 1.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            },
            "suggested_resolution": { "width": 832, "height" : 1216 } 
        },
        {
            "id": "lv2_5_v_sit_exposure",
            "scene_groups": ["bottom_exposure", "innerwear_exposure"],
            "description": "【拒絶と羞恥の丸まり】自らを閉ざし、小さく丸まって震えるポーズ。膝を胸に引き寄せ、隠すように脚を閉じさせ",
            "tags": "sitting, knees to chest, (hug own knees:1.2), (own legs together:1.2), (own knees together:1.2), (crotch focus:1.4), (extreme close-up:1.3), (from below:1.3), (delicate collarbone:1.2), (looking at viewer:1.2), (cinematic lighting:1.2)",
            "min_lv": 2, "max_lv": 3, "weight": 3.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            },
            "suggested_resolution": { "width": 832, "height" : 1216 }
        },
        {
            "id": "lv3_phys_deep_squat",
            "scene_groups": ["bottom_exposure", "innerwear_exposure"],
            "description": "【Lv3:蹲踞の隙】かかとをつけたままの深いしゃがみ込み。閉じた膝の間から、逃げ場のない露出を捉える",
            "tags": "(extremely low angle shot:1.45), (ground-level shot:1.3), (squatting:1.3), (knock knees:1.35), (knees tight together:1.4), (looking at viewer:1.25), (embarrassed:1.25), (deep blush:1.2), (view from between knees:1.4), (panty peek:1.35), (crotch focus:1.3), (solo:1.3)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv3_phys_deep_squat_wet",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "transparency"],
            "description": "【Lv3:蹲踞の隙】かかとをつけたままの深いしゃがみ込み。閉じた膝の間から、逃げ場のない露出を捉える - 濡れ濡れバージョン",
            "tags": "(extremely low angle shot:1.45), (ground-level shot:1.3), (squatting:1.3), (knock knees:1.35), (knees tight together:1.4), (looking at viewer:1.25), (embarrassed:1.25), (deep blush:1.2), (view from between knees:1.4), (panty peek:1.35), (wet_panties:1.35), (soaked_panties:1.25), (crotch focus:1.3), (solo:1.3)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv3_phys_sitting_triangle_wet",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "transparency"],
            "description": "【Lv3:着座の聖域】椅子や床に座った際、太ももの付け根から覗く下着の「三角ゾーン」- 濡れ濡れバージョン",
            "tags": "(wide angle lens:1.3), (high angle:1.3), (sitting:1.3), (knees down:1.1), (knees together:1.1), (pigeon-toed:1.2), (crotch focus:1.2), (wet clothes:1.1), (soaked_panties:1.35), (panty_peek:1.4)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            },
            "suggested_resolution": { "width": 1216, "height" : 832 }
        },
        {
            "id": "lv3_phys_sitting_triangle_stable",
            "scene_groups": ["bottom_exposure", "innerwear_exposure"],
            "description": "【Lv3:着座の聖域】椅子や床に座った際、太ももの付け根から覗く下着の「三角ゾーン」 - 視点真ん中寄り",
            "tags": "(wearing {target_fabric_outer_bottom}:1.4), ({target_fabric_outer_bottom} hem pulled up:1.25), (knees together:1.35), (leaning forward:1.4), (high angle:1.3), (from front:1.25), (foreshortening:1.2), (sitting:1.35), (crotch focus:1.3), (crotch slit:1.25), (visible panties through gap:1.4), (undergarment edge:1.25), (solo:1.3)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            },
            "suggested_resolution": { "width": 1216, "height" : 832 }
        },
        {
            "id": "lv3_true_shirt_disarray",
            "scene_groups": ["top_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "衣服の崩れを写実的に描く（肌質感と布の挙動を重視）",
            "tags": "{camera}, sitting, (off shoulder:1.5), (shirt hanging off shoulder:1.4), (bra peeking:1.2), (subtle cleavage:1.2)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {"top": true, "bottom": false}
        },
        {
            "id": "lv3_true_bent_over_tease",
            "scene_groups": ["bottom_exposure", "innerwear_exposure"],
            "description": "ヒップラインの形状と布の食い込みを写実的に表現",
            "tags": "{camera}, (bent over:1.5), (looking back:1.4), ({target_fabric_outer_bottom} hitched up:1.4), ({target_fabric_outer_bottom} digging into flesh:1.3), (butt focus:1.5), (intense blush:1.3), (heavy breathing:1.3), (sole focus:1.2)",
            "min_lv": 3, "max_lv": 3, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {"top": false, "bottom": true}
        },
        {
            "id": "lv3_true_fetish_constriction",
            "scene_groups": ["bottom_exposure", "top_exposure", "high_risk"],
            "description": "【食い込みと張力】マクロ視点での肉の段差と、衣装の「締め付け」を強調",
            "tags": "{camera}, (macro lens:1.3), (skin indentation:1.6), (tight clothing:1.4), ({target_fabric_outer_bottom} digging into skin:1.5), (creasing skin:1.4), (flesh excess:1.3), (constriction:1.4), (heavy breathing:1.2), (sweat drops on skin:1.1)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv3_true_fetish_transparency",
            "scene_groups": ["top_exposure", "innerwear_exposure", "transparency"],
            "description": "【透けと吸着】『乳首禁止』を前提とした、布越しのシルエット描写",
            "tags": "{camera}, (wearing {target_fabric_outer_top}:1.35), (wet {target_fabric_outer_top}:1.35), ({target_fabric_outer_top} clinging to skin:1.35), (nipple relief:1.25), (wet skin:1.2), (shivering:1.1), (watery eyes:1.2), (solo:1.3)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv3_true_fetish_transparency_stable",
            "scene_groups": ["bottom_exposure", "top_exposure", "innerwear_exposure", "transparency"],
            "description": "【透けと吸着】{camera}によるフェティッシュなアングルで、布越しの下着を描写",
            "tags": "{camera}, (cowboy shot:1.3), (wet clothes:1.3), (translucent {target_fabric_outer_bottom}:1.4), (see-through:1.3), ({target_fabric_outer_bottom} clinging to body:1.3), (bra visible under {target_fabric_outer_top}:1.2), (panty lines:1.3), (shivering:1.1), (no wounds:1.4), (clean skin:1.3)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv3_true_shirt_shredded",
            "scene_groups": ["top_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "【Lv3:衣服の損壊】上着が激しく引き裂かれ、肩や背中が露出。布の破片が肌に張り付く。{camera}で(low_angle)にすれば、破れた布の立体感が強調される",
            "tags": "{camera}, (shredded shirt:1.4), (torn fabric:1.35), (ripped clothes:1.4), (hanging shreds of fabric:1.3), (bra peeking:1.2), (exposed skin:1.4), (heavy breathing:1.3), (sweat:1.2), (disheveled hair:1.2), (desperate expression:1.1)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv3_true_skirt_torn",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "【Lv3:下衣の崩壊】{destructible_fabric}が縦に裂け、脚のラインが剥き出しになる。{camera}の(side_view)で裂け目のエッジを強調",
            "tags": "{camera}, {destructible_fabric}, (ripped hem:1.2), (fabric tears:1.2), (showing thigh:1.2), (panty peeking:1.35), (shivering:1.2), (looking at viewer:1.1)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv3_true_struggle_remnants",
            "scene_groups": ["top_exposure", "clothing_destruction"],
            "description": "【Lv3:抵抗の痕跡】襟元や袖が引きちぎられた状態。{camera}の(close-up)で、破れた布の『繊維のほつれ』を描く",
            "tags": "{camera}, (upper body:1.35), (ripped collar:1.45), (torn sleeves:1.4), (macro shot of torn fabric threads:1.2), (frayed threads:1.35), (tattered edges:1.35), (ripped seams:1.25), (exposed collarbone:1.3), (sobbing:1.1)",
            "min_lv": 3, "max_lv": 3, "weight": 2.0,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            },
            "suggested_resolution": { "width": 832, "height" : 1216 } 
        },
        {
            "id": "lv3_true_skirt_shredded_stable",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "顔の崩れを防ぎつつ、下半身の破壊を確定させるハイブリッド画角",
            "tags": "{camera}, (full body:1.3), (from below:1.4), (lower body focus:1.2), (torn {target_fabric_outer_bottom}:1.4), (panty peeking:1.2), (crotch focus:1.3), (detailed face:1.2), (no_wounds:1.2)",
            "min_lv": 3, "max_lv": 3, "weight": 2.0,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        {
            "id": "lv3_true_shirt_shredded_stable",
            "scene_groups": ["top_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "【上半身の損壊】{camera}によるドラマチックな画角と、激しい布の損壊を両立",
            "tags": "{camera}, (upper body focus:1.3), (cowboy shot:1.2), (shredded {target_fabric_outer_top}:1.35), (torn fabric:1.4), (ripped clothes:1.4), (hanging shreds of fabric:1.3), (bra peeking:1.2), (subtle cleavage:1.2), (exposed skin:1.3), (no wounds:1.2), (clean skin:1.3)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": false
            } 
        },
        {
            "id": "lv3_true_bent_over_tease_stable",
            "scene_groups": ["bottom_exposure", "innerwear_exposure"],
            "description": "【屈曲の美】背後や横からの{camera}演出を活かし、ヒップラインの食い込みを描く",
            "tags": "{camera}, (knee up:1.3), (all fours:1.4), (bent over:1.5), (looking back:1.4), ({target_fabric_outer_bottom} hitched up:1.4), ({target_fabric_outer_bottom} digging into flesh:1.5), (butt focus:1.5), (panty visible:1.4), (intense blush:1.3), (no wounds:1.4), (clean skin:1.3), (crotch exposure:1.3), (underwear visible:1.4)",
            "min_lv": 3, "max_lv": 3, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        { 
            "id": "lv3_true_hand_exploration",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "sexual_activity"],
            "description": "【自己愛】指先の湿感と、多指症を防ぐための「1本」制約",
            "tags": "{camera}, sitting, (fingers in mouth:1.4), (hand on own crotch:1.3), (one hand on crotch:1.3), (masturbation gesture:1.2), ({target_fabric_outer_bottom} lift:1.3), (spread legs:1.2), (wet lips:1.3)",
            "min_lv": 3, "max_lv": 3, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            } 
        },
        { 
            "id": "lv3_true_hand_exploration_stable",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "sexual_activity"],
            "description": "【自己愛】{camera}の寄り具合を制御しつつ、一人での行為に限定",
            "tags": "{camera}, (cowboy shot:1.3), (hand on own crotch:1.3), (one hand on crotch:1.3), (masturbation gesture:1.2), ({target_fabric_outer_bottom} lift:1.4), (spread legs:1.3)",
            "min_lv": 3, "max_lv": 4, "weight": 1.5,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": false,
                "bottom": true
            } 
        },
        {
            "id": "lv3_shredded_skirt_reveal",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "【Lv3:下半身の決壊】スカートが縦に大きく裂け、太ももから腰の下着が露わになる。{camera}で(low_angle)を指定すれば、裂け目の奥行きが強調される",
            "tags": "{camera}, (torn {target_fabric_outer_bottom}:1.4), (ripped {target_fabric_outer_bottom}:1.4), (exposed panties:1.3), (knees up:1.4), (holding knees:1.3), (sitting:1.3), (thigh focus:1.3), (crotch focus:1.2), (no standing:1.2)",
            "min_lv": 3, "max_lv": 3, "weight": 3.0,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            },
            "suggested_resolution": { "width": 1216, "height" : 832 }  
        },
        {
            "id": "lv3_shredded_top_bra_reveal",
            "scene_groups": ["top_exposure", "innerwear_exposure", "clothing_destruction"],
            "description": "【Lv3:胸元の損壊】上着の前面が激しく引き裂かれ、中のブラジャーが完全に露出。{camera}を(close-up)にすれば、破れた布の繊維と肌の質感が際立つ",
            "tags": "{camera}, (upper body focus:1.4), (shredded shirt:1.45), (torn clothing:1.45), (ripped front:1.3), (bra visible:1.25), (cleavage focus:1.25), clothed nipples, (detailed face:1.2), (clean skin:1.3), (no wounds:1.35)",
            "min_lv": 3, "max_lv": 3, "weight": 2.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            },
            "suggested_resolution": { "width": 1216, "height" : 832 }   
        },
        {
            "id": "lv3_phys_panty_pull_down",
            "scene_groups": ["bottom_exposure", "innerwear_exposure", "sexual_activity"],
            "description": "【Lv3:ギリギリの境界線】前かがみの姿勢で、両手で下着の端をわずかに押し下げる仕草。性器露出を避けつつ背徳感を強調",
            "tags": "(three-quarter view:1.4), (from front:1.1), (waist up:1.3), (leaning forward:1.15), (foreshortening:1.1), (looking at viewer:1.2), (blushing cheeks:1.2), (embarrassed:1.2), (partially undressed:1.35), (gaping panties:1.25), (panties down to hips:1.3), (her hands on her own waistband:1.2), (her fingers touching her own panties:1.25), (no panties:1.2)",
            "min_lv": 3, "max_lv": 4, "weight": 2.0,
            "destructible_scene": false,
            "inner_inclusion": {
                "top": true,
                "bottom": false
            },
            "suggested_resolution": { "width": 1216, "height" : 832 }
        },
        {
            "id": "lv4_forced_humiliation_chains",
            "description": "【屈辱の服従】快楽を排し、意思に反して繋がれた屈辱のみを描写。{camera}は(high_angle)で圧迫感を出し、無残に引き裂かれた{destructible_fabric}が尊厳の喪失を強調する",
            "tags": "(all fours:1.4), (bent over:1.3), (from above:1.5), (high angle:1.4), (bird''s eye view:1.2), (looking down at the girl:1.3), (completely undressed:1.4), (heavy iron collar:1.5), (clanking chains:1.3), forced posture, (sobbing:1.1), (crying with eyes open:1.2), (nipples:1.1), (butt focus:1.4), {destructible_fabric}, (cold sweat:1.2), (cinematic grain:1.2)",
            "min_lv": 4, "max_lv": 5, "weight": 3.5,
            "destructible_scene": true,
            "inner_inclusion": {
                "top": true,
                "bottom": true
            }
        }
    ]
}'
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_assets a WHERE a.persona_id = p.id AND a.asset_type = 'scene' AND a.asset_key = 'default');

-- Lotta: wardrobe asset
INSERT INTO personyx.persona_assets (persona_id, asset_type, asset_key, payload)
SELECT p.id, 'wardrobe', 'default', '{
    "colors": ["red", "blue", "green", "black", "white", "pink", "purple", "yellow"],
    "destructible_base_tags": {
        "normal": [
            "(shredded_{target_destructible_top}:1.4)",
            "(torn_{target_destructible_top}:1.4)",
            "(ripped_{target_destructible_top}:1.4)",
            "({target_destructible_bottom}_torn_vertically:1.4)",
            "(fabric_clinging_to_thighs:1.2)",
            "photorealistic"
        ]
    },
    "outfits": [
        {
            "id": "classic_sailor",
            "tags": "classic sailor school uniform, pleated skirt, red neckerchief, realistic_fabric_texture",
            "vibe": "school",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["shirt", "skirt", "neckerchief"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "classic sailor", "bottom": "skirt" }
        },
        {
            "id": "classic_sailor_highsocks",
            "tags": "classic sailor school uniform, pleated skirt, red neckerchief, (thighhighs:1.2), realistic knit texture",
            "vibe": "school",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["shirt", "skirt", "neckerchief", "thighhighs"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "classic sailor", "bottom": "skirt", "socks": "thighhighs" }
        },
        {
            "id": "china_dress",
            "tags": "{color} china dress, short china dress, (deep side slit:1.5), (silk embroidery:1.2), realistic silk sheen",
            "vibe": "sexy",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["dress"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "china dress", "bottom": "dress hem" }
        },
        {
            "id": "office_lady",
            "tags": "office lady, business formal, tight pencil skirt, pantyhose, realistic fabric fall",
            "vibe": "mature",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["shirt", "skirt", "pantyhose"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "shirt", "bottom": "tight pencil skirt" }
        },
        {
            "id": "lingerie_only",
            "tags": "sheer babydoll, lace trim, matching stockings, realistic lace detail",
            "vibe": "sexy",
            "min_lv": 3,
            "max_lv": 4,
            "destructible": true,
            "parts": ["babydoll", "stockings"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "sheer babydoll", "bottom": "babydoll skirt" }
        },
        {
            "id": "blazer_style",
            "tags": "school blazer, plaid skirt, ribbon tie, realistic wool texture",
            "vibe": "school",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["blazer", "shirt", "skirt"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "school blazer", "bottom": "plaid skirt" }
        },
        {
            "id": "gym_uniform",
            "tags": "bloomers, gym shirt, (white socks:1.1), breathable fabric",
            "vibe": "school",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["t-shirt", "bloomers"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [
                "lv2_5_phys_bending_peek",
                "lv2_5_env_windy_front",
                "lv2_5_env_windy_back"
            ],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "gym shirt", "bottom": "bloomers" }
        },
        {
            "id": "oversized_hoodie",
            "tags": "oversized techwear hoodie, tactical joggers, sneakers, realistic fabric",
            "vibe": "cyberpunk",
            "min_lv": 1,
            "max_lv": 3,
            "destructible": false,
            "parts": ["hoodie", "pants"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "oversized hoodie", "bottom": "tactical joggers" }
        },
        {
            "id": "bodysuit",
            "tags": "sleek cyber bodysuit, metallic accents, subtle gloss, realistic reflections",
            "vibe": "cyberpunk",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": false,
            "parts": ["suit"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "cyber bodysuit", "bottom": "cyber bodysuit" }
        },
        {
            "id": "pilot_suit",
            "tags": "80s mecha pilot suit, form-fitting, shoulder pads, worn leather detail",
            "vibe": "cyberpunk",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": false,
            "parts": ["suit"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "pilot suit", "bottom": "pilot suit" }
        },
        {
            "id": "off_shoulder",
            "tags": "oversized off-shoulder knit sweater, denim shorts, knitted texture",
            "vibe": "casual",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["knit", "shorts"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "off-shoulder knit sweater", "bottom": "denim shorts" }
        },
        {
            "id": "sundress",
            "tags": "white summer sundress, straw hat, (thin translucent fabric:1.1), natural wind",
            "vibe": "casual",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["dress"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "sundress top", "bottom": "sundress skirt" }
        },
        {
            "id": "tracksuit",
            "tags": "80s retro tracksuit, side stripes, zip-up jacket, vintage fabric detail",
            "vibe": "casual",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["jacket", "pants"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "tracksuit jacket", "bottom": "tracksuit pants" }
        },
        {
            "id": "evening_dress",
            "tags": "elegant backless evening dress, high slit, silk reflection",
            "vibe": "mature",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["dress"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "evening dress bodice", "bottom": "evening dress skirt" }
        },
        {
            "id": "turtleneck",
            "tags": "tight sleeveless turtleneck, mini skirt, knitted texture",
            "vibe": "mature",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["knit", "skirt"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "sleeveless turtleneck", "bottom": "mini skirt" },
            "conflict_outfits": {
                "accesories_neck": [
                    "{accesories neck parts tags} worn over (sleeveless turtleneck:1.2)"
                ]
            }
        },
        {
            "id": "bikini_armor",
            "tags": "(bikini armor:1.2), (armored bikini:1.2), (metal bikini:1.1), realistic metal shine, leather straps",
            "vibe": "fantasy",
            "min_lv": 2,
            "max_lv": 4,
            "destructible": false,
            "parts": ["armor", "straps"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "bikini armor top", "bottom": "bikini armor bottom" }
        },
        {
            "id": "miko_outfit",
            "tags": "(traditional miko outfit:1.2), (solid white kimono top:1.3), (red hakama:1.2), natural fabric",
            "vibe": "traditional",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "parts": ["kosode", "hakama"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "white kosode", "bottom": "red hakama" }
        },
        {
            "id": "yukata",
            "tags": "floral pattern yukata, obi sash, wooden geta, cotton texture",
            "vibe": "traditional",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["yukata", "obi"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "yukata upper", "bottom": "yukata skirt" }
        },
        {
            "id": "bunny_suit",
            "tags": "(high-leg bunny suit:1.5), bow tie, wrist cuffs, realistic fabric sheen",
            "vibe": "sexy",
            "min_lv": 2,
            "max_lv": 4,
            "destructible": false,
            "parts": ["suit"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "bunny suit", "bottom": "bunny suit" }
        },
        {
            "id": "nurse_outfit",
            "tags": "retro nurse uniform, nurse cap, white stockings, realistic fabric",
            "vibe": "sexy",
            "min_lv": 2,
            "max_lv": 4,
            "destructible": true,
            "parts": ["dress", "cap", "stockings"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "nurse uniform dress", "bottom": "nurse uniform skirt" }
        },
        {
            "id": "swimsuit_80s",
            "tags": "high-leg one-piece swimsuit, neon colors, 80s style, wet fabric detail",
            "vibe": "sexy",
            "min_lv": 2,
            "max_lv": 4,
            "destructible": false,
            "parts": ["swimsuit"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "one-piece swimsuit", "bottom": "one-piece swimsuit" }
        },
        {
            "id": "denim_setup",
            "tags": "denim jacket, button front, denim skirt, matching denim outfit, blue denim, (thighhighs:1.2), detailed_denim_texture",
            "vibe": "casual",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["jacket", "skirt"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "denim jacket", "bottom": "denim skirt" }
        },
        {
            "id": "culottes_white_shirt",
            "tags": "white dress shirt, tucked in, collared shirt, navy blue culottes, skirt pants, natural fabric",
            "vibe": "school",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["shirt", "culottes"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "shirt", "bottom": "culottes" }
        },
        {
            "id": "recruit_suit",
            "tags": "(business suit:1.1), black suit, (tight pencil skirt:1.2), white dress shirt, black pantyhose, realistic tailoring",
            "vibe": "school",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["jacket", "shirt", "skirt", "pantyhose"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "jacket", "bottom": "formal skirt" }
        },
        {
            "id": "tank_top_casual",
            "tags": "(tank top:1.2), (scoop neck:1.1), (colorful tank top:1.3), tucked in, tight fit, fabric detail",
            "vibe": "casual",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["tank_top", "underwear"],
            "incompatible_scene_groups": [
                "bottom_exposure"
            ],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "tank top", "bottom": "denim shorts" }
        },
        {
            "id": "kariyushi_wear",
            "tags": "kariyushi wear, (aloha shirt:1.1), (floral print:1.2), (hibiscus print:1.2), lightweight fabric",
            "vibe": "casual",
            "min_lv": 1,
            "max_lv": 4,
            "destructible": true,
            "parts": ["kariyushi shirt", "slacks", "underwear"],
            "incompatible_scene_logic": [],
            "destructible_tags_key": "normal",
            "outer_tags": { "top": "kariyushi shirt", "bottom": "slacks" }
        }
    ],
    "innerwear_sets": {
        "styles": [
            {
                "id": "black_lace",
                "tags": {
                    "top": "black lace bra",
                    "bottom": "black lace panties"
                },
                "vibe": "mature",
                "min_lv": 2
            },
            {
                "id": "cyber_blue",
                "tags": {
                    "top": "blue sport bra",
                    "bottom": "blue panties"
                },
                "vibe": "cyberpunk",
                "min_lv": 1
            },
            {
                "id": "pink_striped",
                "tags": {
                    "top": "pink and white striped bra",
                    "bottom": "shimapan",
                    "bottom_other": "cute bow"
                },
                "vibe": "cute",
                "min_lv": 1
            },
            {
                "id": "minimal_black",
                "tags": {
                    "top": "micro bikini style bra",
                    "bottom": "black thong",
                    "bottom_other": "(strappy:1.2)"
                },
                "vibe": "sexy",
                "min_lv": 3
            },
            {
                "id": "white_pure",
                "tags": {
                    "top": "simple white bra",
                    "bottom": "white panties",
                    "bottom_other": "(satin:1.1)"
                },
                "vibe": "school",
                "min_lv": 1
            },
            {
                "id": "no_bra_mode",
                "tags": {
                    "top": "no bra",
                    "top_other": "(nipples visible through fabric:1.3)",
                    "bottom": "no panties"
                },
                "vibe": "sexy",
                "min_lv": 4
            }
        ]
    }
}
'
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_assets a WHERE a.persona_id = p.id AND a.asset_type = 'wardrobe' AND a.asset_key = 'default');

-- Lotta: faceid reference image node_42
INSERT INTO personyx.persona_asset_files (persona_id, asset_type, asset_key, file_url, file_name, mime_type)
SELECT p.id, 'faceid', 'node_42', 'https://personyx.r2.unchainworks.com/Lotta/face_id/lotta_ref_1.png', 'lotta_ref_1.png', 'image/png'
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_asset_files f WHERE f.persona_id = p.id AND f.asset_type = 'faceid' AND f.asset_key = 'node_42');

-- Lotta: faceid reference image node_43
INSERT INTO personyx.persona_asset_files (persona_id, asset_type, asset_key, file_url, file_name, mime_type)
SELECT p.id, 'faceid', 'node_43', 'https://personyx.r2.unchainworks.com/Lotta/face_id/lotta_ref_2.png', 'lotta_ref_2.png', 'image/png'
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_asset_files f WHERE f.persona_id = p.id AND f.asset_type = 'faceid' AND f.asset_key = 'node_43');

-- Lotta: faceid reference image node_50
INSERT INTO personyx.persona_asset_files (persona_id, asset_type, asset_key, file_url, file_name, mime_type)
SELECT p.id, 'faceid', 'node_50', 'https://personyx.r2.unchainworks.com/Lotta/face_id/lotta_ref_3.png', 'lotta_ref_3.png', 'image/png'
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_asset_files f WHERE f.persona_id = p.id AND f.asset_type = 'faceid' AND f.asset_key = 'node_50');

-- Lotta: faceid reference image node_51
INSERT INTO personyx.persona_asset_files (persona_id, asset_type, asset_key, file_url, file_name, mime_type)
SELECT p.id, 'faceid', 'node_51', 'https://personyx.r2.unchainworks.com/Lotta/face_id/lotta_ref_4.png', 'lotta_ref_4.png', 'image/png'
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_asset_files f WHERE f.persona_id = p.id AND f.asset_type = 'faceid' AND f.asset_key = 'node_51');

-- Lotta: faceid reference image node_53
INSERT INTO personyx.persona_asset_files (persona_id, asset_type, asset_key, file_url, file_name, mime_type)
SELECT p.id, 'faceid', 'node_53', 'https://personyx.r2.unchainworks.com/Lotta/face_id/lotta_ref_5.png', 'lotta_ref_5.png', 'image/png'
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_asset_files f WHERE f.persona_id = p.id AND f.asset_type = 'faceid' AND f.asset_key = 'node_53');

-- Lotta: faceid color match image
INSERT INTO personyx.persona_asset_files (persona_id, asset_type, asset_key, file_url, file_name, mime_type)
SELECT p.id, 'faceid', 'color_match', 'https://personyx.r2.unchainworks.com/Lotta/face_id/lotta_color_match_1.png', 'lotta_color_match_1.png', 'image/png'
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_asset_files f WHERE f.persona_id = p.id AND f.asset_type = 'faceid' AND f.asset_key = 'color_match');

-- Lotta: api workflow api/lotta-IPAdapter9_face_test.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'lotta-IPAdapter9_face_test.json', '{
  "5": {
    "inputs": {
      "seed": 876592600176522,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "dpmpp_3m_sde",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 1024,
      "height": 1024,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "7": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "9": {
    "inputs": {
      "image": "calrota_00019_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ponyRealism_V22.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 0.8,
      "weight_faceidv2": 1.5,
      "weight_type": "ease in",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "27",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, rating_explicit BREAK source_photo, photorealistic, realistic, RAW photo, 8k uhd, dslr BREAK 1woman, adult, (korean or taiwanese ethnicity:1.2), (light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris, (single mole under right eye:1.35), (silver hoop earrings:1.1), (black velvet choker:1.1), (looking viewer:1.3)",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "(worst quality, low quality:1.4), bad anatomy, text, logo, watermark, oversaturated colors, (plastic texture:1.2), (cartoon:1.3), (multiple moles:1.4), (freckles:1.4), (oversharpen:1.2), (unnatural skin tone:1.3), (lens artifact:1.2), (bad anatomy:1.3), (extra fingers:1.4), (deformed limbs:1.3), (penis:1.1), (dick:1.1), (cock:1.1), (unrealistic proportions:1.2), (plastic skin:1.2), plastic_texture, lens_flare_artifact, (anime:1.3), 3d, render, blurry, lowres, bad hands, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 0.8,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  },
  "26": {
    "inputs": {
      "image": "calrota_00006_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "27": {
    "inputs": {
      "image1": [
        "26",
        0
      ],
      "image2": [
        "9",
        0
      ],
      "image3": [
        "28",
        0
      ]
    },
    "class_type": "ImpactMakeImageBatch",
    "_meta": {
      "title": "Make Image Batch"
    }
  },
  "28": {
    "inputs": {
      "image": "calrota_00027_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "29": {
    "inputs": {
      "model_name": "bbox/face_yolov8m.pt"
    },
    "class_type": "UltralyticsDetectorProvider",
    "_meta": {
      "title": "UltralyticsDetectorProvider"
    }
  },
  "39": {
    "inputs": {
      "filename_prefix": "Lotta_test",
      "images": [
        "7",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "40": {
    "inputs": {
      "weight": 0.8,
      "weight_faceidv2": 1.5,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "27",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "41": {
    "inputs": {
      "seed": 398432204741211,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "dpmpp_3m_sde",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "40",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "42": {
    "inputs": {
      "samples": [
        "41",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "43": {
    "inputs": {
      "filename_prefix": "Lotta_test",
      "images": [
        "42",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  }
}', FALSE
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'lotta-IPAdapter9_face_test.json');

-- Lotta: api workflow api/lotta-IPAdapter9_no_upscale.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'lotta-IPAdapter9_no_upscale.json', '{
  "5": {
    "inputs": {
      "seed": 635949384746543,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "dpmpp_3m_sde",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 1216,
      "height": 832,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "7": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "8": {
    "inputs": {
      "filename_prefix": "aoi",
      "images": [
        "7",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "9": {
    "inputs": {
      "image": "carlota.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ponyRealism_V22.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 0.8,
      "weight_faceidv2": 1.25,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "9",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, rating_explicit, source_photo, realistic, photorealistic, RAW photo, 8k uhd, dslr,1woman, brown eyes, (light brown hair:1.1), long hair, (straight bangs:1.25),(wide angle shot:1.2), (high angle:1.3), (sitting:1.2), (kneeling:1.2), (knees together:1.2), (pigeon-toed:1.1), (crotch focus:1.1), (blue denim jacket:1.25), button front, unbuttoned, (matching blue denim skirt:1.25), same color denim, (black thighhighs:1.3), thigh high stockings, bare thighs, zettai ryouiki, (white panties visible under skirt:1.2), (panties peek from between thighs:1.2), underwear glimpse BREAK shopping mall, interior, dramatic sun shafts, moody lighting",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "(source_anime:1.2), (source_cartoon:1.2), (source_pony:1.2), 2d, 3d render, cgi, illustration, drawing, painting, vector art, anime style, flat shading, cel shading, digital art, plastic skin, airbrushed, smooth skin, oversized eyes, unrealistic proportions",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 0.8,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  }
}', FALSE
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'lotta-IPAdapter9_no_upscale.json');

-- Lotta: api workflow api/lotta-IPAdapter9_three_src.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'lotta-IPAdapter9_three_src.json', '{
  "5": {
    "inputs": {
      "seed": 397958140236539,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "dpmpp_3m_sde",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 1216,
      "height": 832,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "7": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "8": {
    "inputs": {
      "filename_prefix": "aoi",
      "images": [
        "7",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "9": {
    "inputs": {
      "image": "calrota_00019_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ponyRealism_V22.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 0.8,
      "weight_faceidv2": 1.5,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "27",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, rating_questionable BREAK source_photo, realistic, RAW photo, 8k uhd, dslr BREAK (light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris BREAK (from_above:1.4), (high_angle:1.3), (bird''s_eye_view:1.1), atmospheric_lighting, (leaning_forward:1.5), (looking_down_at_viewer:1.4), (curious_expression:1.2) BREAK denim_jacket, button_front, denim_skirt, matching_denim_outfit, blue_denim, (thighhighs:1.2), detailed_denim_texture BREAK japanese room, tatami, futon, paper lantern, sliding doors, warm_tone, sunlight filtering through, dappled light, volumetric_rays,watercolor effect, artistic, painterly BREAK masterpiece, high quality",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "low quality, bad anatomy, text, watermark, oversaturated colors, cartoon, plastic_texture, lens_flare_artifact, (plastic_texture:1.2), (cartoon:1.5), (oversharpen:1.2), (unnatural_skin_tone:1.3), (lens_artifact:1.2), (bad_anatomy:1.3), (extra_fingers:1.4), (deformed_limbs:1.3), (explicit_nipples:1.0), (explicit_genitalia:1.0), (graphic_sexual_content:1.2), (worst quality:1.4), (low quality:1.4), lowres, bad anatomy, bad hands, text, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 0.8,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  },
  "26": {
    "inputs": {
      "image": "calrota_00006_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "27": {
    "inputs": {
      "image1": [
        "26",
        0
      ],
      "image2": [
        "9",
        0
      ],
      "image3": [
        "28",
        0
      ]
    },
    "class_type": "ImpactMakeImageBatch",
    "_meta": {
      "title": "Make Image Batch"
    }
  },
  "28": {
    "inputs": {
      "image": "calrota_00027_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  }
}', FALSE
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'lotta-IPAdapter9_three_src.json');

-- Lotta: api workflow api/lotta-IPAdapter9_three_src_fd.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'lotta-IPAdapter9_three_src_fd.json', '{
  "5": {
    "inputs": {
      "seed": 937522503923701,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "dpmpp_3m_sde",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 1216,
      "height": 832,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "7": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "8": {
    "inputs": {
      "filename_prefix": "aoi",
      "images": [
        "7",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "9": {
    "inputs": {
      "image": "calrota_00019_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ponyRealism_V22.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 0.8,
      "weight_faceidv2": 1.5,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "27",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, rating_questionable BREAK source_photo, realistic, RAW photo, 8k uhd, dslr BREAK (light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris BREAK (from_above:1.4), (high_angle:1.3), (bird''s_eye_view:1.1), atmospheric_lighting, (leaning_forward:1.5), (looking_down_at_viewer:1.4), (curious_expression:1.2) BREAK denim_jacket, button_front, denim_skirt, matching_denim_outfit, blue_denim, (thighhighs:1.2), detailed_denim_texture BREAK japanese room, tatami, futon, paper lantern, sliding doors, warm_tone, sunlight filtering through, dappled light, volumetric_rays,watercolor effect, artistic, painterly BREAK masterpiece, high quality",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "low quality, bad anatomy, text, watermark, oversaturated colors, cartoon, plastic_texture, lens_flare_artifact, (plastic_texture:1.2), (cartoon:1.5), (oversharpen:1.2), (unnatural_skin_tone:1.3), (lens_artifact:1.2), (bad_anatomy:1.3), (extra_fingers:1.4), (deformed_limbs:1.3), (explicit_nipples:1.0), (explicit_genitalia:1.0), (graphic_sexual_content:1.2), (worst quality:1.4), (low quality:1.4), lowres, bad anatomy, bad hands, text, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 0.8,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  },
  "26": {
    "inputs": {
      "image": "calrota_00006_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "27": {
    "inputs": {
      "image1": [
        "26",
        0
      ],
      "image2": [
        "9",
        0
      ],
      "image3": [
        "28",
        0
      ]
    },
    "class_type": "ImpactMakeImageBatch",
    "_meta": {
      "title": "Make Image Batch"
    }
  },
  "28": {
    "inputs": {
      "image": "calrota_00027_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "29": {
    "inputs": {
      "model_name": "bbox/face_yolov8m.pt"
    },
    "class_type": "UltralyticsDetectorProvider",
    "_meta": {
      "title": "UltralyticsDetectorProvider"
    }
  },
  "30": {
    "inputs": {
      "guide_size": 512,
      "guide_size_for": true,
      "max_size": 1024,
      "seed": 902978488662259,
      "steps": 20,
      "cfg": 8,
      "sampler_name": "euler",
      "scheduler": "simple",
      "denoise": 0.5,
      "feather": 5,
      "noise_mask": true,
      "force_inpaint": true,
      "bbox_threshold": 0.5,
      "bbox_dilation": 10,
      "bbox_crop_factor": 3,
      "sam_detection_hint": "center-1",
      "sam_dilation": 0,
      "sam_threshold": 0.93,
      "sam_bbox_expansion": 0,
      "sam_mask_hint_threshold": 0.7,
      "sam_mask_hint_use_negative": "False",
      "drop_size": 10,
      "wildcard": "",
      "cycle": 1,
      "inpaint_model": false,
      "noise_mask_feather": 20,
      "tiled_encode": false,
      "tiled_decode": false,
      "image": [
        "7",
        0
      ],
      "model": [
        "11",
        0
      ],
      "clip": [
        "10",
        1
      ],
      "vae": [
        "10",
        2
      ],
      "positive": [
        "31",
        0
      ],
      "negative": [
        "32",
        0
      ],
      "bbox_detector": [
        "29",
        0
      ]
    },
    "class_type": "FaceDetailer",
    "_meta": {
      "title": "FaceDetailer"
    }
  },
  "31": {
    "inputs": {
      "text": "source_photo, realistic, RAW photo, 8k uhd, dslr , (light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "32": {
    "inputs": {
      "text": "(worst quality, low quality:1.4), deformed, bad eyes, anime, 3d, render, illustration, plastic skin, smooth skin, (open mouth), (cum, saliva, spit, drool), mouth fluids, white substance",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "33": {
    "inputs": {
      "filename_prefix": "lotta_fd",
      "images": [
        "30",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  }
}', FALSE
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'lotta-IPAdapter9_three_src_fd.json');

-- Lotta: api workflow api/lotta-IPAdapter9_three_src_fd2.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'lotta-IPAdapter9_three_src_fd2.json', '{
  "5": {
    "inputs": {
      "seed": 406783288130962,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "dpmpp_3m_sde",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 1216,
      "height": 832,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "7": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "8": {
    "inputs": {
      "filename_prefix": "aoi",
      "images": [
        "7",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "9": {
    "inputs": {
      "image": "calrota_00019_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ponyRealism_V22.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 0.8,
      "weight_faceidv2": 1.5,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "27",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, rating_questionable BREAK source_photo, realistic, RAW photo, 8k uhd, dslr BREAK (light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris BREAK (from_above:1.4), (high_angle:1.3), (bird''s_eye_view:1.1), atmospheric_lighting, (leaning_forward:1.5), (looking_down_at_viewer:1.4), (curious_expression:1.2) BREAK denim_jacket, button_front, denim_skirt, matching_denim_outfit, blue_denim, (thighhighs:1.2), detailed_denim_texture BREAK japanese room, tatami, futon, paper lantern, sliding doors, warm_tone, sunlight filtering through, dappled light, volumetric_rays,watercolor effect, artistic, painterly BREAK masterpiece, high quality",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "low quality, bad anatomy, text, watermark, oversaturated colors, cartoon, plastic_texture, lens_flare_artifact, (plastic_texture:1.2), (cartoon:1.5), (oversharpen:1.2), (unnatural_skin_tone:1.3), (lens_artifact:1.2), (bad_anatomy:1.3), (extra_fingers:1.4), (deformed_limbs:1.3), (explicit_nipples:1.0), (explicit_genitalia:1.0), (graphic_sexual_content:1.2), (worst quality:1.4), (low quality:1.4), lowres, bad anatomy, bad hands, text, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 0.8,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  },
  "26": {
    "inputs": {
      "image": "calrota_00006_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "27": {
    "inputs": {
      "image1": [
        "26",
        0
      ],
      "image2": [
        "9",
        0
      ],
      "image3": [
        "28",
        0
      ]
    },
    "class_type": "ImpactMakeImageBatch",
    "_meta": {
      "title": "Make Image Batch"
    }
  },
  "28": {
    "inputs": {
      "image": "calrota_00027_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "29": {
    "inputs": {
      "model_name": "bbox/face_yolov8m.pt"
    },
    "class_type": "UltralyticsDetectorProvider",
    "_meta": {
      "title": "UltralyticsDetectorProvider"
    }
  },
  "30": {
    "inputs": {
      "guide_size": 512,
      "guide_size_for": true,
      "max_size": 1024,
      "seed": 154319139816053,
      "steps": 20,
      "cfg": 8,
      "sampler_name": "euler",
      "scheduler": "simple",
      "denoise": 0.2,
      "feather": 5,
      "noise_mask": true,
      "force_inpaint": true,
      "bbox_threshold": 0.5,
      "bbox_dilation": 10,
      "bbox_crop_factor": 3,
      "sam_detection_hint": "center-1",
      "sam_dilation": 0,
      "sam_threshold": 0.93,
      "sam_bbox_expansion": 0,
      "sam_mask_hint_threshold": 0.7,
      "sam_mask_hint_use_negative": "False",
      "drop_size": 10,
      "wildcard": "",
      "cycle": 1,
      "inpaint_model": false,
      "noise_mask_feather": 20,
      "tiled_encode": false,
      "tiled_decode": false,
      "image": [
        "7",
        0
      ],
      "model": [
        "11",
        0
      ],
      "clip": [
        "10",
        1
      ],
      "vae": [
        "10",
        2
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "32",
        0
      ],
      "bbox_detector": [
        "29",
        0
      ]
    },
    "class_type": "FaceDetailer",
    "_meta": {
      "title": "FaceDetailer"
    }
  },
  "31": {
    "inputs": {
      "text": "source_photo, realistic, RAW photo, 8k uhd, dslr , (light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "32": {
    "inputs": {
      "text": "(worst quality, low quality:1.4), deformed, bad eyes, anime, 3d, render, illustration, plastic skin, smooth skin, (open mouth), (cum, saliva, spit, drool), mouth fluids, white substance",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "33": {
    "inputs": {
      "filename_prefix": "lotta_fd",
      "images": [
        "30",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  }
}', FALSE
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'lotta-IPAdapter9_three_src_fd2.json');

-- Lotta: api workflow api/lotta-IPAdapter9_three_src_fd3.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'lotta-IPAdapter9_three_src_fd3.json', '{
  "5": {
    "inputs": {
      "seed": 606553058531661,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "dpmpp_3m_sde",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 1216,
      "height": 832,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "7": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "8": {
    "inputs": {
      "filename_prefix": "Lotta_fd3",
      "images": [
        "35:15",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "9": {
    "inputs": {
      "image": "calrota_00019_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ponyRealism_V22.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 0.8,
      "weight_faceidv2": 1.5,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "27",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, rating_explicit BREAK source_photo, realistic, RAW photo, 8k uhd, dslr BREAK (light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris, (silver hoop earrings:1.1), (black velvet choker:1.1), (single beauty mark under eye:1.35), (mole under eye:1.2), smile, open mouth BREAK (three-quarter view:1.1), (from front:1.1), (waist up:1.3), (leaning forward:1.15), (foreshortening:1.1), (looking at viewer:1.2), (blushing cheeks:1.2), (embarrassed:1.2), (partially undressed:1.35), (gaping panties:1.25),(panties down to hips:1.3), (hands on waistband:1.15), (fingers touching panties:1.3), (no panties:1.2) BREAK photorealistic, tight sleeveless turtleneck, mini skirt, knitted_texture, blue_sport_bra, (black velvet choker:1.1) worn over (sleeveless_turtleneck:1.2) BREAK photorealistic, sci-fi laboratory, futuristic, specular_surfaces, soft_blue_ambient,photorealistic, soft natural light, diffuse_light,dust particles, atmospheric haze, floating_particles BREAK masterpiece, high quality",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "low quality, bad anatomy, text, watermark, oversaturated colors, cartoon, plastic_texture, lens_flare_artifact, (plastic_texture:1.2), (cartoon:1.5), (oversharpen:1.2), (unnatural_skin_tone:1.3), (lens_artifact:1.2), (bad_anatomy:1.3), (extra_fingers:1.4), (deformed_limbs:1.3), (penis:1.1), (dick:1.1), (cock:1.1), (unrealistic_proportions:1.2), (worst quality:1.4), (low quality:1.4), lowres, bad anatomy, bad hands, text, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 0.8,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  },
  "26": {
    "inputs": {
      "image": "calrota_00006_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "27": {
    "inputs": {
      "image1": [
        "26",
        0
      ],
      "image2": [
        "9",
        0
      ],
      "image3": [
        "28",
        0
      ]
    },
    "class_type": "ImpactMakeImageBatch",
    "_meta": {
      "title": "Make Image Batch"
    }
  },
  "28": {
    "inputs": {
      "image": "calrota_00027_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "29": {
    "inputs": {
      "model_name": "bbox/face_yolov8m.pt"
    },
    "class_type": "UltralyticsDetectorProvider",
    "_meta": {
      "title": "UltralyticsDetectorProvider"
    }
  },
  "30": {
    "inputs": {
      "guide_size": 512,
      "guide_size_for": true,
      "max_size": 1024,
      "seed": 225641105015397,
      "steps": 20,
      "cfg": 7.5,
      "sampler_name": "euler",
      "scheduler": "simple",
      "denoise": 0.5,
      "feather": 5,
      "noise_mask": true,
      "force_inpaint": true,
      "bbox_threshold": 0.5,
      "bbox_dilation": 10,
      "bbox_crop_factor": 3,
      "sam_detection_hint": "center-1",
      "sam_dilation": 0,
      "sam_threshold": 0.93,
      "sam_bbox_expansion": 0,
      "sam_mask_hint_threshold": 0.7,
      "sam_mask_hint_use_negative": "False",
      "drop_size": 10,
      "wildcard": "",
      "cycle": 1,
      "inpaint_model": false,
      "noise_mask_feather": 20,
      "tiled_encode": false,
      "tiled_decode": false,
      "image": [
        "7",
        0
      ],
      "model": [
        "11",
        0
      ],
      "clip": [
        "10",
        1
      ],
      "vae": [
        "10",
        2
      ],
      "positive": [
        "31",
        0
      ],
      "negative": [
        "32",
        0
      ],
      "bbox_detector": [
        "29",
        0
      ]
    },
    "class_type": "FaceDetailer",
    "_meta": {
      "title": "FaceDetailer"
    }
  },
  "31": {
    "inputs": {
      "text": "source_photo, realistic, RAW photo, 8k uhd, dslr ,(japanese girl:1.2), (east asian ethnicity:1.2), (light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "32": {
    "inputs": {
      "text": "(worst quality, low quality:1.4), deformed, bad eyes, anime, 3d, render, illustration, plastic skin, smooth skin, (open mouth), (cum, saliva, spit, drool), mouth fluids, white substance",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "34": {
    "inputs": {
      "color_space": "LAB",
      "factor": 0.6,
      "device": "auto",
      "batch_size": 0,
      "image": [
        "30",
        0
      ],
      "reference": [
        "37",
        0
      ]
    },
    "class_type": "ImageColorMatch+",
    "_meta": {
      "title": "🔧 Image Color Match"
    }
  },
  "37": {
    "inputs": {
      "image": "pandoraup029245.jpg"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "35:15": {
    "inputs": {
      "fragment_shader": "#version 300 es\nprecision highp float;\n\nuniform sampler2D u_image0;\nuniform vec2 u_resolution;\nuniform float u_float0; // grain amount      [0.0 – 1.0]   typical: 0.2–0.8\nuniform float u_float1; // grain size        [0.3 – 3.0]   lower = finer grain\nuniform float u_float2; // color amount      [0.0 – 1.0]   0 = monochrome, 1 = RGB grain\nuniform float u_float3; // luminance bias    [0.0 – 1.0]   0 = uniform, 1 = shadows only\nuniform int   u_int0;   // noise mode        [0 or 1]      0 = smooth, 1 = grainy\n\nin vec2 v_texCoord;\nlayout(location = 0) out vec4 fragColor0;\n\n// High-quality integer hash (pcg-like)\nuint pcg(uint v) {\n    uint state = v * 747796405u + 2891336453u;\n    uint word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;\n    return (word >> 22u) ^ word;\n}\n\n// 2D -> 1D hash input\nuint hash2d(uvec2 p) {\n    return pcg(p.x + pcg(p.y));\n}\n\n// Hash to float [0, 1]\nfloat hashf(uvec2 p) {\n    return float(hash2d(p)) / float(0xffffffffu);\n}\n\n// Hash to float with offset (for RGB channels)\nfloat hashf(uvec2 p, uint offset) {\n    return float(pcg(hash2d(p) + offset)) / float(0xffffffffu);\n}\n\n// Convert uniform [0,1] to roughly Gaussian distribution\n// Using simple approximation: average of multiple samples\nfloat toGaussian(uvec2 p) {\n    float sum = hashf(p, 0u) + hashf(p, 1u) + hashf(p, 2u) + hashf(p, 3u);\n    return (sum - 2.0) * 0.7;  // Centered, scaled\n}\n\nfloat toGaussian(uvec2 p, uint offset) {\n    float sum = hashf(p, offset) + hashf(p, offset + 1u) \n              + hashf(p, offset + 2u) + hashf(p, offset + 3u);\n    return (sum - 2.0) * 0.7;\n}\n\n// Smooth noise with better interpolation\nfloat smoothNoise(vec2 p) {\n    vec2 i = floor(p);\n    vec2 f = fract(p);\n    \n    // Quintic interpolation (less banding than cubic)\n    f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);\n    \n    uvec2 ui = uvec2(i);\n    float a = toGaussian(ui);\n    float b = toGaussian(ui + uvec2(1u, 0u));\n    float c = toGaussian(ui + uvec2(0u, 1u));\n    float d = toGaussian(ui + uvec2(1u, 1u));\n    \n    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);\n}\n\nfloat smoothNoise(vec2 p, uint offset) {\n    vec2 i = floor(p);\n    vec2 f = fract(p);\n    \n    f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);\n    \n    uvec2 ui = uvec2(i);\n    float a = toGaussian(ui, offset);\n    float b = toGaussian(ui + uvec2(1u, 0u), offset);\n    float c = toGaussian(ui + uvec2(0u, 1u), offset);\n    float d = toGaussian(ui + uvec2(1u, 1u), offset);\n    \n    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);\n}\n\nvoid main() {\n    vec4 color = texture(u_image0, v_texCoord);\n    \n    // Luminance (Rec.709)\n    float luma = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));\n    \n    // Grain UV (resolution-independent)\n    vec2 grainUV = v_texCoord * u_resolution / max(u_float1, 0.01);\n    uvec2 grainPixel = uvec2(grainUV);\n    \n    float g;\n    vec3 grainRGB;\n    \n    if (u_int0 == 1) {\n        // Grainy mode: pure hash noise (no interpolation = no banding)\n        g = toGaussian(grainPixel);\n        grainRGB = vec3(\n            toGaussian(grainPixel, 100u),\n            toGaussian(grainPixel, 200u),\n            toGaussian(grainPixel, 300u)\n        );\n    } else {\n        // Smooth mode: interpolated with quintic curve\n        g = smoothNoise(grainUV);\n        grainRGB = vec3(\n            smoothNoise(grainUV, 100u),\n            smoothNoise(grainUV, 200u),\n            smoothNoise(grainUV, 300u)\n        );\n    }\n    \n    // Luminance weighting (less grain in highlights)\n    float lumWeight = mix(1.0, 1.0 - luma, clamp(u_float3, 0.0, 1.0));\n    \n    // Strength\n    float strength = u_float0 * 0.15;\n    \n    // Color vs monochrome grain\n    vec3 grainColor = mix(vec3(g), grainRGB, clamp(u_float2, 0.0, 1.0));\n    \n    color.rgb += grainColor * strength * lumWeight;\n    fragColor0 = vec4(clamp(color.rgb, 0.0, 1.0), color.a);\n}\n",
      "size_mode": "from_input",
      "images.image0": [
        "34",
        0
      ],
      "floats.u_float0": [
        "35:17",
        0
      ],
      "floats.u_float1": [
        "35:18",
        0
      ],
      "floats.u_float2": [
        "35:19",
        0
      ],
      "floats.u_float3": [
        "35:20",
        0
      ],
      "ints.u_int0": [
        "35:21",
        1
      ]
    },
    "class_type": "GLSLShader",
    "_meta": {
      "title": "GLSLシェーダー"
    }
  },
  "35:21": {
    "inputs": {
      "choice": "Smooth",
      "index": 0,
      "option1": "Smooth",
      "option2": "Grainy",
      "option3": ""
    },
    "class_type": "CustomCombo",
    "_meta": {
      "title": "カスタムコンボ"
    }
  },
  "35:17": {
    "inputs": {
      "value": 0.03
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Grain amount"
    }
  },
  "35:18": {
    "inputs": {
      "value": 1.5
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Grain size"
    }
  },
  "35:19": {
    "inputs": {
      "value": 0.6
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Color amount"
    }
  },
  "35:20": {
    "inputs": {
      "value": 0.4
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Luminance bias"
    }
  }
}', FALSE
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'lotta-IPAdapter9_three_src_fd3.json');

-- Lotta: api workflow api/lotta-IPAdapter9_three_src_fd4.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'lotta-IPAdapter9_three_src_fd4.json', '{
  "5": {
    "inputs": {
      "seed": 315569543325797,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "dpmpp_3m_sde",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 1216,
      "height": 832,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "7": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "8": {
    "inputs": {
      "filename_prefix": "Lotta_fd3",
      "images": [
        "35:15",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "9": {
    "inputs": {
      "image": "calrota_00019_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ponyRealism_V22.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 0.8,
      "weight_faceidv2": 1.5,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "27",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, rating_safe BREAK source_photo, realistic, RAW photo, 8k uhd, dslr BREAK (light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris, open mouth, smile, (single beauty mark under eye:1.35), (mole under eye:1.2), (silver hoop earrings:1.1), (black velvet choker:1.1) BREAK photorealistic, (over_the_shoulder:1.3), (point_of_view:1.1), (partial_obscured_view:1.1), subtle_depth, (buttoning:1.7), (adjusting_clothes:1.5), (fingers_on_button:1.6) BREAK photorealistic, office_lady, business_formal, tight_pencil_skirt, pantyhose, realistic_fabric_fall, black_lace_bra BREAK photorealistic, cafe, at table, ambient_interior_light, cup_reflection,photorealistic, backlighting, silhouette, rim_light,watercolor effect, artistic, painterly BREAK masterpiece, high quality",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "low quality, bad anatomy, text, watermark, oversaturated colors, cartoon, plastic_texture, lens_flare_artifact, (plastic_texture:1.2), (cartoon:1.5), (oversharpen:1.2), (unnatural_skin_tone:1.3), (lens_artifact:1.2), (bad_anatomy:1.3), (extra_fingers:1.4), (deformed_limbs:1.3), (explicit_nipples:1.0), (explicit_genitalia:1.0), (graphic_sexual_content:1.2), (worst quality:1.4), (low quality:1.4), lowres, bad anatomy, bad hands, text, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 0.8,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  },
  "26": {
    "inputs": {
      "image": "calrota_00006_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "27": {
    "inputs": {
      "image1": [
        "26",
        0
      ],
      "image2": [
        "9",
        0
      ],
      "image3": [
        "28",
        0
      ]
    },
    "class_type": "ImpactMakeImageBatch",
    "_meta": {
      "title": "Make Image Batch"
    }
  },
  "28": {
    "inputs": {
      "image": "calrota_00027_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "29": {
    "inputs": {
      "model_name": "bbox/face_yolov8m.pt"
    },
    "class_type": "UltralyticsDetectorProvider",
    "_meta": {
      "title": "UltralyticsDetectorProvider"
    }
  },
  "30": {
    "inputs": {
      "guide_size": 512,
      "guide_size_for": true,
      "max_size": 1024,
      "seed": 537135256254282,
      "steps": 30,
      "cfg": 4,
      "sampler_name": "euler",
      "scheduler": "simple",
      "denoise": 0.5,
      "feather": 5,
      "noise_mask": true,
      "force_inpaint": true,
      "bbox_threshold": 0.5,
      "bbox_dilation": 10,
      "bbox_crop_factor": 3,
      "sam_detection_hint": "center-1",
      "sam_dilation": 0,
      "sam_threshold": 0.93,
      "sam_bbox_expansion": 0,
      "sam_mask_hint_threshold": 0.7,
      "sam_mask_hint_use_negative": "False",
      "drop_size": 10,
      "wildcard": "",
      "cycle": 1,
      "inpaint_model": false,
      "noise_mask_feather": 20,
      "tiled_encode": false,
      "tiled_decode": false,
      "image": [
        "7",
        0
      ],
      "model": [
        "11",
        0
      ],
      "clip": [
        "10",
        1
      ],
      "vae": [
        "10",
        2
      ],
      "positive": [
        "31",
        0
      ],
      "negative": [
        "32",
        0
      ],
      "bbox_detector": [
        "29",
        0
      ]
    },
    "class_type": "FaceDetailer",
    "_meta": {
      "title": "FaceDetailer"
    }
  },
  "31": {
    "inputs": {
      "text": "source_photo, realistic, RAW photo, 8k uhd, dslr ,(japanese girl:1.2), (east asian ethnicity:1.2), (light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris, (single beauty mark under eye:1.35), (mole under eye:1.2), (silver hoop earrings:1.1), (black velvet choker:1.1), (subtle smile:1.2), (soft smile:1.15), (crinkly eyes:1.2), (blushing cheeks:1.15), detailed eyes",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "32": {
    "inputs": {
      "text": "(worst quality, low quality:1.4), deformed, bad eyes, anime, 3d, render, illustration, plastic skin, smooth skin, (open mouth), (cum, saliva, spit, drool), mouth fluids, white substance",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "34": {
    "inputs": {
      "color_space": "LAB",
      "factor": 0.6,
      "device": "auto",
      "batch_size": 0,
      "image": [
        "30",
        0
      ],
      "reference": [
        "37",
        0
      ]
    },
    "class_type": "ImageColorMatch+",
    "_meta": {
      "title": "🔧 Image Color Match"
    }
  },
  "37": {
    "inputs": {
      "image": "pandoraup029245.jpg"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "35:21": {
    "inputs": {
      "choice": "Smooth",
      "index": 0,
      "option1": "Smooth",
      "option2": "Grainy",
      "option3": ""
    },
    "class_type": "CustomCombo",
    "_meta": {
      "title": "カスタムコンボ"
    }
  },
  "35:17": {
    "inputs": {
      "value": 0
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Grain amount"
    }
  },
  "35:18": {
    "inputs": {
      "value": 1.5
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Grain size"
    }
  },
  "35:19": {
    "inputs": {
      "value": 0.6
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Color amount"
    }
  },
  "35:20": {
    "inputs": {
      "value": 0.4
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Luminance bias"
    }
  },
  "35:15": {
    "inputs": {
      "fragment_shader": "#version 300 es\nprecision highp float;\n\nuniform sampler2D u_image0;\nuniform vec2 u_resolution;\nuniform float u_float0; // grain amount      [0.0 – 1.0]   typical: 0.2–0.8\nuniform float u_float1; // grain size        [0.3 – 3.0]   lower = finer grain\nuniform float u_float2; // color amount      [0.0 – 1.0]   0 = monochrome, 1 = RGB grain\nuniform float u_float3; // luminance bias    [0.0 – 1.0]   0 = uniform, 1 = shadows only\nuniform int   u_int0;   // noise mode        [0 or 1]      0 = smooth, 1 = grainy\n\nin vec2 v_texCoord;\nlayout(location = 0) out vec4 fragColor0;\n\n// High-quality integer hash (pcg-like)\nuint pcg(uint v) {\n    uint state = v * 747796405u + 2891336453u;\n    uint word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;\n    return (word >> 22u) ^ word;\n}\n\n// 2D -> 1D hash input\nuint hash2d(uvec2 p) {\n    return pcg(p.x + pcg(p.y));\n}\n\n// Hash to float [0, 1]\nfloat hashf(uvec2 p) {\n    return float(hash2d(p)) / float(0xffffffffu);\n}\n\n// Hash to float with offset (for RGB channels)\nfloat hashf(uvec2 p, uint offset) {\n    return float(pcg(hash2d(p) + offset)) / float(0xffffffffu);\n}\n\n// Convert uniform [0,1] to roughly Gaussian distribution\n// Using simple approximation: average of multiple samples\nfloat toGaussian(uvec2 p) {\n    float sum = hashf(p, 0u) + hashf(p, 1u) + hashf(p, 2u) + hashf(p, 3u);\n    return (sum - 2.0) * 0.7;  // Centered, scaled\n}\n\nfloat toGaussian(uvec2 p, uint offset) {\n    float sum = hashf(p, offset) + hashf(p, offset + 1u) \n              + hashf(p, offset + 2u) + hashf(p, offset + 3u);\n    return (sum - 2.0) * 0.7;\n}\n\n// Smooth noise with better interpolation\nfloat smoothNoise(vec2 p) {\n    vec2 i = floor(p);\n    vec2 f = fract(p);\n    \n    // Quintic interpolation (less banding than cubic)\n    f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);\n    \n    uvec2 ui = uvec2(i);\n    float a = toGaussian(ui);\n    float b = toGaussian(ui + uvec2(1u, 0u));\n    float c = toGaussian(ui + uvec2(0u, 1u));\n    float d = toGaussian(ui + uvec2(1u, 1u));\n    \n    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);\n}\n\nfloat smoothNoise(vec2 p, uint offset) {\n    vec2 i = floor(p);\n    vec2 f = fract(p);\n    \n    f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);\n    \n    uvec2 ui = uvec2(i);\n    float a = toGaussian(ui, offset);\n    float b = toGaussian(ui + uvec2(1u, 0u), offset);\n    float c = toGaussian(ui + uvec2(0u, 1u), offset);\n    float d = toGaussian(ui + uvec2(1u, 1u), offset);\n    \n    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);\n}\n\nvoid main() {\n    vec4 color = texture(u_image0, v_texCoord);\n    \n    // Luminance (Rec.709)\n    float luma = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));\n    \n    // Grain UV (resolution-independent)\n    vec2 grainUV = v_texCoord * u_resolution / max(u_float1, 0.01);\n    uvec2 grainPixel = uvec2(grainUV);\n    \n    float g;\n    vec3 grainRGB;\n    \n    if (u_int0 == 1) {\n        // Grainy mode: pure hash noise (no interpolation = no banding)\n        g = toGaussian(grainPixel);\n        grainRGB = vec3(\n            toGaussian(grainPixel, 100u),\n            toGaussian(grainPixel, 200u),\n            toGaussian(grainPixel, 300u)\n        );\n    } else {\n        // Smooth mode: interpolated with quintic curve\n        g = smoothNoise(grainUV);\n        grainRGB = vec3(\n            smoothNoise(grainUV, 100u),\n            smoothNoise(grainUV, 200u),\n            smoothNoise(grainUV, 300u)\n        );\n    }\n    \n    // Luminance weighting (less grain in highlights)\n    float lumWeight = mix(1.0, 1.0 - luma, clamp(u_float3, 0.0, 1.0));\n    \n    // Strength\n    float strength = u_float0 * 0.15;\n    \n    // Color vs monochrome grain\n    vec3 grainColor = mix(vec3(g), grainRGB, clamp(u_float2, 0.0, 1.0));\n    \n    color.rgb += grainColor * strength * lumWeight;\n    fragColor0 = vec4(clamp(color.rgb, 0.0, 1.0), color.a);\n}\n",
      "size_mode": "from_input",
      "images.image0": [
        "34",
        0
      ],
      "floats.u_float0": [
        "35:17",
        0
      ],
      "floats.u_float1": [
        "35:18",
        0
      ],
      "floats.u_float2": [
        "35:19",
        0
      ],
      "floats.u_float3": [
        "35:20",
        0
      ],
      "ints.u_int0": [
        "35:21",
        1
      ]
    },
    "class_type": "GLSLShader",
    "_meta": {
      "title": "GLSLシェーダー"
    }
  }
}', FALSE
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'lotta-IPAdapter9_three_src_fd4.json');

-- Lotta: api workflow api/lotta-IPAdapter9_three_src_fd5.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'lotta-IPAdapter9_three_src_fd5.json', '{
  "5": {
    "inputs": {
      "seed": 242302767955326,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "dpmpp_3m_sde",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 832,
      "height": 1216,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "7": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "8": {
    "inputs": {
      "filename_prefix": "Lotta_fd3",
      "images": [
        "35:15",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "9": {
    "inputs": {
      "image": "calrota_00019_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ponyRealism_V22.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 1,
      "weight_faceidv2": 1.5,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "27",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, rating_explicit BREAK source_photo, photorealistic, realistic, RAW photo, 8k uhd, dslr BREAK 1woman, adult, (korean or taiwanese ethnicity:1.2),(light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris, (single mole under right eye:1.35), (silver hoop earrings:1.1), (black velvet choker:1.1) BREAK  (wearing simple white bra:1.4), (shirt removed:1.35), (shirt pulled down off shoulders:1.4), (her own slender female hand pulling shirt off shoulder:1.4), (her own other female hand resting on her own hand:1.35), (off-shoulder:1.3), (shivering:1.1), (watery eyes:1.2), (sobbing:1.1), (upper body:1.35) ",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "(worst quality, low quality:1.4), bad anatomy, text, logo, watermark, oversaturated colors, (plastic texture:1.2), (cartoon:1.3), (oversharpen:1.2), (unnatural skin tone:1.3), (lens artifact:1.2), (bad anatomy:1.3), (extra fingers:1.4), (deformed limbs:1.3), (explicit nipples:1.0), (explicit genitalia:1.0), (graphic sexual content:1.2), (two people:1.45), (multiple people:1.4), (2people:1.45), (plastic skin:1.2), plastic_texture, lens_flare_artifact, (anime:1.3), 3d, render, blurry, lowres, bad hands, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 0.8,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  },
  "26": {
    "inputs": {
      "image": "calrota_00006_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "27": {
    "inputs": {
      "image1": [
        "26",
        0
      ],
      "image2": [
        "9",
        0
      ],
      "image3": [
        "28",
        0
      ],
      "image4": [
        "38",
        0
      ],
      "image5": [
        "39",
        0
      ]
    },
    "class_type": "ImpactMakeImageBatch",
    "_meta": {
      "title": "Make Image Batch"
    }
  },
  "28": {
    "inputs": {
      "image": "calrota_00027_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "29": {
    "inputs": {
      "model_name": "bbox/face_yolov8m.pt"
    },
    "class_type": "UltralyticsDetectorProvider",
    "_meta": {
      "title": "UltralyticsDetectorProvider"
    }
  },
  "30": {
    "inputs": {
      "guide_size": 512,
      "guide_size_for": true,
      "max_size": 1024,
      "seed": 736644913484184,
      "steps": 30,
      "cfg": 4,
      "sampler_name": "euler",
      "scheduler": "simple",
      "denoise": 0.35,
      "feather": 5,
      "noise_mask": true,
      "force_inpaint": true,
      "bbox_threshold": 0.25,
      "bbox_dilation": 10,
      "bbox_crop_factor": 2,
      "sam_detection_hint": "center-1",
      "sam_dilation": 0,
      "sam_threshold": 0.93,
      "sam_bbox_expansion": 0,
      "sam_mask_hint_threshold": 0.7,
      "sam_mask_hint_use_negative": "False",
      "drop_size": 10,
      "wildcard": "",
      "cycle": 1,
      "inpaint_model": false,
      "noise_mask_feather": 20,
      "tiled_encode": false,
      "tiled_decode": false,
      "image": [
        "7",
        0
      ],
      "model": [
        "11",
        0
      ],
      "clip": [
        "10",
        1
      ],
      "vae": [
        "10",
        2
      ],
      "positive": [
        "31",
        0
      ],
      "negative": [
        "32",
        0
      ],
      "bbox_detector": [
        "29",
        0
      ]
    },
    "class_type": "FaceDetailer",
    "_meta": {
      "title": "FaceDetailer"
    }
  },
  "31": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, rating_safe,source_photo, photorealistic, realistic, RAW photo, 8k uhd, dslr,1woman, adult, (korean or taiwanese ethnicity:1.2),(light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris, (single mole under right eye:1.35), (silver hoop earrings:1.1), (black velvet choker:1.1),(startled expression:1.25), (wide eyes:1.15), (gasping:1.2), surprised look, (looking at viewer:1.15)",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "32": {
    "inputs": {
      "text": "(worst quality, low quality:1.4), bad anatomy, text, logo, watermark, oversaturated colors,(two people:1.45), (multiple people:1.4), (2people:1.45), (plastic skin:1.2), plastic_texture, lens_flare_artifact, (anime:1.3), 3d, render, blurry, lowres, bad hands, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "34": {
    "inputs": {
      "color_space": "LAB",
      "factor": 1,
      "device": "auto",
      "batch_size": 0,
      "image": [
        "30",
        0
      ],
      "reference": [
        "37",
        0
      ]
    },
    "class_type": "ImageColorMatch+",
    "_meta": {
      "title": "🔧 Image Color Match"
    }
  },
  "37": {
    "inputs": {
      "image": "carlota.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "38": {
    "inputs": {
      "image": "calrota_00016_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "39": {
    "inputs": {
      "image": "calrota_00031_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "35:21": {
    "inputs": {
      "choice": "Smooth",
      "index": 0,
      "option1": "Smooth",
      "option2": "Grainy",
      "option3": ""
    },
    "class_type": "CustomCombo",
    "_meta": {
      "title": "カスタムコンボ"
    }
  },
  "35:17": {
    "inputs": {
      "value": 0
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Grain amount"
    }
  },
  "35:18": {
    "inputs": {
      "value": 1.5
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Grain size"
    }
  },
  "35:19": {
    "inputs": {
      "value": 0.6
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Color amount"
    }
  },
  "35:20": {
    "inputs": {
      "value": 0.4
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Luminance bias"
    }
  },
  "35:15": {
    "inputs": {
      "fragment_shader": "#version 300 es\nprecision highp float;\n\nuniform sampler2D u_image0;\nuniform vec2 u_resolution;\nuniform float u_float0; // grain amount      [0.0 – 1.0]   typical: 0.2–0.8\nuniform float u_float1; // grain size        [0.3 – 3.0]   lower = finer grain\nuniform float u_float2; // color amount      [0.0 – 1.0]   0 = monochrome, 1 = RGB grain\nuniform float u_float3; // luminance bias    [0.0 – 1.0]   0 = uniform, 1 = shadows only\nuniform int   u_int0;   // noise mode        [0 or 1]      0 = smooth, 1 = grainy\n\nin vec2 v_texCoord;\nlayout(location = 0) out vec4 fragColor0;\n\n// High-quality integer hash (pcg-like)\nuint pcg(uint v) {\n    uint state = v * 747796405u + 2891336453u;\n    uint word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;\n    return (word >> 22u) ^ word;\n}\n\n// 2D -> 1D hash input\nuint hash2d(uvec2 p) {\n    return pcg(p.x + pcg(p.y));\n}\n\n// Hash to float [0, 1]\nfloat hashf(uvec2 p) {\n    return float(hash2d(p)) / float(0xffffffffu);\n}\n\n// Hash to float with offset (for RGB channels)\nfloat hashf(uvec2 p, uint offset) {\n    return float(pcg(hash2d(p) + offset)) / float(0xffffffffu);\n}\n\n// Convert uniform [0,1] to roughly Gaussian distribution\n// Using simple approximation: average of multiple samples\nfloat toGaussian(uvec2 p) {\n    float sum = hashf(p, 0u) + hashf(p, 1u) + hashf(p, 2u) + hashf(p, 3u);\n    return (sum - 2.0) * 0.7;  // Centered, scaled\n}\n\nfloat toGaussian(uvec2 p, uint offset) {\n    float sum = hashf(p, offset) + hashf(p, offset + 1u) \n              + hashf(p, offset + 2u) + hashf(p, offset + 3u);\n    return (sum - 2.0) * 0.7;\n}\n\n// Smooth noise with better interpolation\nfloat smoothNoise(vec2 p) {\n    vec2 i = floor(p);\n    vec2 f = fract(p);\n    \n    // Quintic interpolation (less banding than cubic)\n    f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);\n    \n    uvec2 ui = uvec2(i);\n    float a = toGaussian(ui);\n    float b = toGaussian(ui + uvec2(1u, 0u));\n    float c = toGaussian(ui + uvec2(0u, 1u));\n    float d = toGaussian(ui + uvec2(1u, 1u));\n    \n    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);\n}\n\nfloat smoothNoise(vec2 p, uint offset) {\n    vec2 i = floor(p);\n    vec2 f = fract(p);\n    \n    f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);\n    \n    uvec2 ui = uvec2(i);\n    float a = toGaussian(ui, offset);\n    float b = toGaussian(ui + uvec2(1u, 0u), offset);\n    float c = toGaussian(ui + uvec2(0u, 1u), offset);\n    float d = toGaussian(ui + uvec2(1u, 1u), offset);\n    \n    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);\n}\n\nvoid main() {\n    vec4 color = texture(u_image0, v_texCoord);\n    \n    // Luminance (Rec.709)\n    float luma = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));\n    \n    // Grain UV (resolution-independent)\n    vec2 grainUV = v_texCoord * u_resolution / max(u_float1, 0.01);\n    uvec2 grainPixel = uvec2(grainUV);\n    \n    float g;\n    vec3 grainRGB;\n    \n    if (u_int0 == 1) {\n        // Grainy mode: pure hash noise (no interpolation = no banding)\n        g = toGaussian(grainPixel);\n        grainRGB = vec3(\n            toGaussian(grainPixel, 100u),\n            toGaussian(grainPixel, 200u),\n            toGaussian(grainPixel, 300u)\n        );\n    } else {\n        // Smooth mode: interpolated with quintic curve\n        g = smoothNoise(grainUV);\n        grainRGB = vec3(\n            smoothNoise(grainUV, 100u),\n            smoothNoise(grainUV, 200u),\n            smoothNoise(grainUV, 300u)\n        );\n    }\n    \n    // Luminance weighting (less grain in highlights)\n    float lumWeight = mix(1.0, 1.0 - luma, clamp(u_float3, 0.0, 1.0));\n    \n    // Strength\n    float strength = u_float0 * 0.15;\n    \n    // Color vs monochrome grain\n    vec3 grainColor = mix(vec3(g), grainRGB, clamp(u_float2, 0.0, 1.0));\n    \n    color.rgb += grainColor * strength * lumWeight;\n    fragColor0 = vec4(clamp(color.rgb, 0.0, 1.0), color.a);\n}\n",
      "size_mode": "from_input",
      "images.image0": [
        "34",
        0
      ],
      "floats.u_float0": [
        "35:17",
        0
      ],
      "floats.u_float1": [
        "35:18",
        0
      ],
      "floats.u_float2": [
        "35:19",
        0
      ],
      "floats.u_float3": [
        "35:20",
        0
      ],
      "ints.u_int0": [
        "35:21",
        1
      ]
    },
    "class_type": "GLSLShader",
    "_meta": {
      "title": "GLSLシェーダー"
    }
  }
}', FALSE
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'lotta-IPAdapter9_three_src_fd5.json');

-- Lotta: api workflow api/lotta-IPAdapter9_three_src_fd5_strongm_v_0.33.0_2.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'lotta-IPAdapter9_three_src_fd5_strongm_v_0.33.0_2.json', '{
  "5": {
    "inputs": {
      "seed": 53245170958389,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "dpmpp_2m_sde",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 1216,
      "height": 832,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "7": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "8": {
    "inputs": {
      "filename_prefix": "Lotta_fd3",
      "images": [
        "41",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ponyRealism_V22.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 0.75,
      "weight_faceidv2": 0.9,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "52",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, (japanese woman:1.15), (light brown hair:1.1), long dark brown hair, (straight bangs:1.1)",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "(worst quality, low quality:1.4), bad anatomy, text, logo, watermark, oversaturated colors, (plastic texture:1.2), (cartoon:1.3), (oversharpen:1.2), (unnatural skin tone:1.3), (lens artifact:1.2), (bad anatomy:1.3), (extra fingers:1.4), (deformed limbs:1.3), (explicit nipples:1.0), (explicit genitalia:1.0), (graphic sexual content:1.2), (two people:1.45), (multiple people:1.4), (2people:1.45), (plastic skin:1.2), plastic_texture, lens_flare_artifact, (anime:1.3), 3d, render, blurry, lowres, bad hands, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 0.85,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA",
      "model_name": "buffalo_l"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  },
  "27": {
    "inputs": {
      "image1": [
        "42",
        0
      ],
      "image2": [
        "43",
        0
      ],
      "image3": [
        "50",
        0
      ],
      "image4": [
        "51",
        0
      ],
      "image5": [
        "53",
        0
      ]
    },
    "class_type": "ImpactMakeImageBatch",
    "_meta": {
      "title": "Make Image Batch"
    }
  },
  "29": {
    "inputs": {
      "model_name": "bbox/face_yolov8m.pt"
    },
    "class_type": "UltralyticsDetectorProvider",
    "_meta": {
      "title": "UltralyticsDetectorProvider"
    }
  },
  "30": {
    "inputs": {
      "guide_size": 1024,
      "guide_size_for": true,
      "max_size": 1024,
      "seed": 279959692404076,
      "steps": 40,
      "cfg": 4,
      "sampler_name": "dpmpp_2m_sde",
      "scheduler": "karras",
      "denoise": 0.35,
      "feather": 5,
      "noise_mask": true,
      "force_inpaint": true,
      "bbox_threshold": 0.25,
      "bbox_dilation": 10,
      "bbox_crop_factor": 2,
      "sam_detection_hint": "center-1",
      "sam_dilation": 0,
      "sam_threshold": 0.93,
      "sam_bbox_expansion": 0,
      "sam_mask_hint_threshold": 0.7,
      "sam_mask_hint_use_negative": "False",
      "drop_size": 10,
      "wildcard": "",
      "cycle": 1,
      "inpaint_model": false,
      "noise_mask_feather": 20,
      "tiled_encode": false,
      "tiled_decode": false,
      "image": [
        "7",
        0
      ],
      "model": [
        "11",
        0
      ],
      "clip": [
        "10",
        1
      ],
      "vae": [
        "10",
        2
      ],
      "positive": [
        "31",
        0
      ],
      "negative": [
        "32",
        0
      ],
      "bbox_detector": [
        "29",
        0
      ]
    },
    "class_type": "FaceDetailer",
    "_meta": {
      "title": "FaceDetailer"
    }
  },
  "31": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, rating_questionable, 1woman, brown eyes, (single mole under right eye:1.35)",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "32": {
    "inputs": {
      "text": "(worst quality, low quality:1.4), bad anatomy, text, logo, watermark, oversaturated colors,(two people:1.45), (multiple people:1.4), (2people:1.45), (plastic skin:1.2), plastic_texture, lens_flare_artifact, (anime:1.3), 3d, render, blurry, lowres, bad hands, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "34": {
    "inputs": {
      "color_space": "LAB",
      "factor": 1,
      "device": "auto",
      "batch_size": 0,
      "image": [
        "30",
        0
      ],
      "reference": [
        "37",
        0
      ]
    },
    "class_type": "ImageColorMatch+",
    "_meta": {
      "title": "🔧 Image Color Match"
    }
  },
  "37": {
    "inputs": {
      "image": "carlota.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "41": {
    "inputs": {
      "density": 0.2,
      "intensity": 0.1,
      "highlights": 0.85,
      "supersample_factor": 4,
      "image": [
        "34",
        0
      ]
    },
    "class_type": "Image Film Grain",
    "_meta": {
      "title": "Image Film Grain"
    }
  },
  "42": {
    "inputs": {
      "image": "calrota_00001_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "43": {
    "inputs": {
      "image": "calrota_00030_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "50": {
    "inputs": {
      "image": "carlota.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "51": {
    "inputs": {
      "image": "calrota_00016_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "52": {
    "inputs": {
      "left": 8,
      "top": 8,
      "right": 8,
      "bottom": 8,
      "feathering": 40,
      "image": [
        "27",
        0
      ]
    },
    "class_type": "ImagePadForOutpaint",
    "_meta": {
      "title": "アウトペイント用に画像をパッド"
    }
  },
  "53": {
    "inputs": {
      "image": "calrota_00027_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  }
}', TRUE
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'lotta-IPAdapter9_three_src_fd5_strongm_v_0.33.0_2.json');

-- Lotta: api workflow api/lotta-IPAdapter9_ultra_upscale.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'lotta-IPAdapter9_ultra_upscale.json', '{
  "5": {
    "inputs": {
      "seed": 415108799477252,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "dpmpp_3m_sde",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 1216,
      "height": 832,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "7": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "8": {
    "inputs": {
      "filename_prefix": "aoi",
      "images": [
        "7",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "9": {
    "inputs": {
      "image": "calrota_00021_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ponyRealism_V22.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 0.8,
      "weight_faceidv2": 2,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "9",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, rating_explicit, source_photo, realistic, photorealistic, RAW photo, 8k uhd, dslr,1girl, (korean or taiwanese ethnicity:1.2), brown eyes, (light brown hair:1.1), long hair, (straight bangs:1.25),(wide angle shot:1.2), (high angle:1.3), (sitting:1.2), (kneeling:1.2), (knees together:1.2), (pigeon-toed:1.1), (crotch focus:1.1), (blue denim jacket:1.25), button front, unbuttoned, (matching blue denim skirt:1.25), same color denim, (black thighhighs:1.3), thigh high stockings, bare thighs, zettai ryouiki, (white panties visible under skirt:1.2), (panties peek from between thighs:1.2), underwear glimpse BREAK shopping mall, interior, dramatic sun shafts, moody lighting",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "(source_anime:1.2), (source_cartoon:1.2), (source_pony:1.2), 2d, 3d render, cgi, illustration, drawing, painting, vector art, anime style, flat shading, cel shading, digital art, plastic skin, airbrushed, smooth skin, oversized eyes, unrealistic proportions",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 0.8,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  },
  "26": {
    "inputs": {
      "upscale_by": 2,
      "seed": 47069148853120,
      "steps": 20,
      "cfg": 8,
      "sampler_name": "euler",
      "scheduler": "simple",
      "denoise": 0.2,
      "mode_type": "Linear",
      "tile_width": 1024,
      "tile_height": 1024,
      "mask_blur": 8,
      "tile_padding": 32,
      "seam_fix_mode": "None",
      "seam_fix_denoise": 1,
      "seam_fix_width": 64,
      "seam_fix_mask_blur": 8,
      "seam_fix_padding": 16,
      "force_uniform_tiles": true,
      "tiled_decode": false,
      "batch_size": 1,
      "image": [
        "7",
        0
      ],
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "vae": [
        "10",
        2
      ],
      "upscale_model": [
        "28",
        0
      ]
    },
    "class_type": "UltimateSDUpscale",
    "_meta": {
      "title": "Ultimate SD Upscale"
    }
  },
  "27": {
    "inputs": {
      "filename_prefix": "SD_up",
      "images": [
        "26",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "28": {
    "inputs": {
      "model_name": "RealESRGAN_x4plus.pth"
    },
    "class_type": "Upscale Model Loader",
    "_meta": {
      "title": "Upscale Model Loader"
    }
  }
}', FALSE
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'lotta-IPAdapter9_ultra_upscale.json');

-- Lotta: api workflow api/lotta-IPAdapter9_ultra_upscale_fd4.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'api', 'lotta-IPAdapter9_ultra_upscale_fd4.json', '{
  "5": {
    "inputs": {
      "seed": 508448482250466,
      "steps": 30,
      "cfg": 5.5,
      "sampler_name": "dpmpp_3m_sde",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "latent_image": [
        "6",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "Kサンプラー"
    }
  },
  "6": {
    "inputs": {
      "width": 1216,
      "height": 832,
      "batch_size": 1
    },
    "class_type": "EmptyLatentImage",
    "_meta": {
      "title": "空の潜在画像"
    }
  },
  "7": {
    "inputs": {
      "samples": [
        "5",
        0
      ],
      "vae": [
        "10",
        2
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAEデコード"
    }
  },
  "8": {
    "inputs": {
      "filename_prefix": "Lotta_fd3",
      "images": [
        "35:15",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "9": {
    "inputs": {
      "image": "calrota_00019_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "10": {
    "inputs": {
      "ckpt_name": "ponyRealism_V22.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": {
      "title": "チェックポイントを読み込む"
    }
  },
  "11": {
    "inputs": {
      "weight": 0.8,
      "weight_faceidv2": 1.5,
      "weight_type": "strong middle",
      "combine_embeds": "concat",
      "start_at": 0,
      "end_at": 1,
      "embeds_scaling": "V only",
      "model": [
        "24",
        0
      ],
      "ipadapter": [
        "24",
        1
      ],
      "image": [
        "27",
        0
      ],
      "clip_vision": [
        "23",
        0
      ],
      "insightface": [
        "25",
        0
      ]
    },
    "class_type": "IPAdapterFaceID",
    "_meta": {
      "title": "IPAdapter FaceID"
    }
  },
  "12": {
    "inputs": {
      "text": "score_9, score_8_up, score_7_up, rating_safe BREAK source_photo, realistic, RAW photo, 8k uhd, dslr BREAK (light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris, open mouth, smile, (single beauty mark under eye:1.35), (mole under eye:1.2), (silver hoop earrings:1.1), (black velvet choker:1.1) BREAK photorealistic, (over_the_shoulder:1.3), (point_of_view:1.1), (partial_obscured_view:1.1), subtle_depth, (buttoning:1.7), (adjusting_clothes:1.5), (fingers_on_button:1.6) BREAK photorealistic, office_lady, business_formal, tight_pencil_skirt, pantyhose, realistic_fabric_fall, black_lace_bra BREAK photorealistic, cafe, at table, ambient_interior_light, cup_reflection,photorealistic, backlighting, silhouette, rim_light,watercolor effect, artistic, painterly BREAK masterpiece, high quality",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "13": {
    "inputs": {
      "text": "low quality, bad anatomy, text, watermark, oversaturated colors, cartoon, plastic_texture, lens_flare_artifact, (plastic_texture:1.2), (cartoon:1.5), (oversharpen:1.2), (unnatural_skin_tone:1.3), (lens_artifact:1.2), (bad_anatomy:1.3), (extra_fingers:1.4), (deformed_limbs:1.3), (explicit_nipples:1.0), (explicit_genitalia:1.0), (graphic_sexual_content:1.2), (worst quality:1.4), (low quality:1.4), lowres, bad anatomy, bad hands, text, error, blurry",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "23": {
    "inputs": {
      "clip_name": "CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    },
    "class_type": "CLIPVisionLoader",
    "_meta": {
      "title": "CLIPビジョンを読み込む"
    }
  },
  "24": {
    "inputs": {
      "preset": "FACEID PLUS V2",
      "lora_strength": 0.8,
      "provider": "CUDA",
      "model": [
        "10",
        0
      ]
    },
    "class_type": "IPAdapterUnifiedLoaderFaceID",
    "_meta": {
      "title": "IPAdapter Unified Loader FaceID"
    }
  },
  "25": {
    "inputs": {
      "provider": "CUDA"
    },
    "class_type": "IPAdapterInsightFaceLoader",
    "_meta": {
      "title": "IPAdapter InsightFace Loader"
    }
  },
  "26": {
    "inputs": {
      "image": "calrota_00006_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "27": {
    "inputs": {
      "image1": [
        "26",
        0
      ],
      "image2": [
        "9",
        0
      ],
      "image3": [
        "28",
        0
      ]
    },
    "class_type": "ImpactMakeImageBatch",
    "_meta": {
      "title": "Make Image Batch"
    }
  },
  "28": {
    "inputs": {
      "image": "calrota_00027_.png"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "29": {
    "inputs": {
      "model_name": "bbox/face_yolov8m.pt"
    },
    "class_type": "UltralyticsDetectorProvider",
    "_meta": {
      "title": "UltralyticsDetectorProvider"
    }
  },
  "30": {
    "inputs": {
      "guide_size": 512,
      "guide_size_for": true,
      "max_size": 1024,
      "seed": 820869617819739,
      "steps": 30,
      "cfg": 4,
      "sampler_name": "euler",
      "scheduler": "simple",
      "denoise": 0.5,
      "feather": 5,
      "noise_mask": true,
      "force_inpaint": true,
      "bbox_threshold": 0.5,
      "bbox_dilation": 10,
      "bbox_crop_factor": 3,
      "sam_detection_hint": "center-1",
      "sam_dilation": 0,
      "sam_threshold": 0.93,
      "sam_bbox_expansion": 0,
      "sam_mask_hint_threshold": 0.7,
      "sam_mask_hint_use_negative": "False",
      "drop_size": 10,
      "wildcard": "",
      "cycle": 1,
      "inpaint_model": false,
      "noise_mask_feather": 20,
      "tiled_encode": false,
      "tiled_decode": false,
      "image": [
        "7",
        0
      ],
      "model": [
        "11",
        0
      ],
      "clip": [
        "10",
        1
      ],
      "vae": [
        "10",
        2
      ],
      "positive": [
        "31",
        0
      ],
      "negative": [
        "32",
        0
      ],
      "bbox_detector": [
        "29",
        0
      ]
    },
    "class_type": "FaceDetailer",
    "_meta": {
      "title": "FaceDetailer"
    }
  },
  "31": {
    "inputs": {
      "text": "source_photo, realistic, RAW photo, 8k uhd, dslr ,(japanese girl:1.2), (east asian ethnicity:1.2), (light brown hair:1.1), long hair, (straight bangs:1.25), brown eyes, detailed iris, (single beauty mark under eye:1.35), (mole under eye:1.2), (silver hoop earrings:1.1), (black velvet choker:1.1), (subtle smile:1.2), (soft smile:1.15), (crinkly eyes:1.2), (blushing cheeks:1.15), detailed eyes",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "32": {
    "inputs": {
      "text": "(worst quality, low quality:1.4), deformed, bad eyes, anime, 3d, render, illustration, plastic skin, smooth skin, (open mouth), (cum, saliva, spit, drool), mouth fluids, white substance",
      "clip": [
        "10",
        1
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIPテキストエンコード（プロンプト）"
    }
  },
  "34": {
    "inputs": {
      "color_space": "LAB",
      "factor": 0.6,
      "device": "auto",
      "batch_size": 0,
      "image": [
        "38",
        0
      ],
      "reference": [
        "37",
        0
      ]
    },
    "class_type": "ImageColorMatch+",
    "_meta": {
      "title": "🔧 Image Color Match"
    }
  },
  "37": {
    "inputs": {
      "image": "pandoraup029245.jpg"
    },
    "class_type": "LoadImage",
    "_meta": {
      "title": "画像を読み込む"
    }
  },
  "38": {
    "inputs": {
      "upscale_by": 2,
      "seed": 410545739496656,
      "steps": 20,
      "cfg": 8,
      "sampler_name": "euler",
      "scheduler": "simple",
      "denoise": 0.2,
      "mode_type": "Linear",
      "tile_width": 1024,
      "tile_height": 1024,
      "mask_blur": 8,
      "tile_padding": 32,
      "seam_fix_mode": "None",
      "seam_fix_denoise": 1,
      "seam_fix_width": 64,
      "seam_fix_mask_blur": 8,
      "seam_fix_padding": 16,
      "force_uniform_tiles": true,
      "tiled_decode": false,
      "batch_size": 1,
      "image": [
        "30",
        0
      ],
      "model": [
        "11",
        0
      ],
      "positive": [
        "12",
        0
      ],
      "negative": [
        "13",
        0
      ],
      "vae": [
        "10",
        2
      ],
      "upscale_model": [
        "39",
        0
      ]
    },
    "class_type": "UltimateSDUpscale",
    "_meta": {
      "title": "Ultimate SD Upscale"
    }
  },
  "39": {
    "inputs": {
      "model_name": "RealESRGAN_x4plus.pth"
    },
    "class_type": "Upscale Model Loader",
    "_meta": {
      "title": "Upscale Model Loader"
    }
  },
  "40": {
    "inputs": {
      "filename_prefix": "Lotta_fd3_us",
      "images": [
        "38",
        0
      ]
    },
    "class_type": "SaveImage",
    "_meta": {
      "title": "画像を保存"
    }
  },
  "35:21": {
    "inputs": {
      "choice": "Smooth",
      "index": 0,
      "option1": "Smooth",
      "option2": "Grainy",
      "option3": ""
    },
    "class_type": "CustomCombo",
    "_meta": {
      "title": "カスタムコンボ"
    }
  },
  "35:17": {
    "inputs": {
      "value": 0
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Grain amount"
    }
  },
  "35:18": {
    "inputs": {
      "value": 1.5
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Grain size"
    }
  },
  "35:19": {
    "inputs": {
      "value": 0.6
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Color amount"
    }
  },
  "35:20": {
    "inputs": {
      "value": 0.4
    },
    "class_type": "PrimitiveFloat",
    "_meta": {
      "title": "Luminance bias"
    }
  },
  "35:15": {
    "inputs": {
      "fragment_shader": "#version 300 es\nprecision highp float;\n\nuniform sampler2D u_image0;\nuniform vec2 u_resolution;\nuniform float u_float0; // grain amount      [0.0 – 1.0]   typical: 0.2–0.8\nuniform float u_float1; // grain size        [0.3 – 3.0]   lower = finer grain\nuniform float u_float2; // color amount      [0.0 – 1.0]   0 = monochrome, 1 = RGB grain\nuniform float u_float3; // luminance bias    [0.0 – 1.0]   0 = uniform, 1 = shadows only\nuniform int   u_int0;   // noise mode        [0 or 1]      0 = smooth, 1 = grainy\n\nin vec2 v_texCoord;\nlayout(location = 0) out vec4 fragColor0;\n\n// High-quality integer hash (pcg-like)\nuint pcg(uint v) {\n    uint state = v * 747796405u + 2891336453u;\n    uint word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;\n    return (word >> 22u) ^ word;\n}\n\n// 2D -> 1D hash input\nuint hash2d(uvec2 p) {\n    return pcg(p.x + pcg(p.y));\n}\n\n// Hash to float [0, 1]\nfloat hashf(uvec2 p) {\n    return float(hash2d(p)) / float(0xffffffffu);\n}\n\n// Hash to float with offset (for RGB channels)\nfloat hashf(uvec2 p, uint offset) {\n    return float(pcg(hash2d(p) + offset)) / float(0xffffffffu);\n}\n\n// Convert uniform [0,1] to roughly Gaussian distribution\n// Using simple approximation: average of multiple samples\nfloat toGaussian(uvec2 p) {\n    float sum = hashf(p, 0u) + hashf(p, 1u) + hashf(p, 2u) + hashf(p, 3u);\n    return (sum - 2.0) * 0.7;  // Centered, scaled\n}\n\nfloat toGaussian(uvec2 p, uint offset) {\n    float sum = hashf(p, offset) + hashf(p, offset + 1u) \n              + hashf(p, offset + 2u) + hashf(p, offset + 3u);\n    return (sum - 2.0) * 0.7;\n}\n\n// Smooth noise with better interpolation\nfloat smoothNoise(vec2 p) {\n    vec2 i = floor(p);\n    vec2 f = fract(p);\n    \n    // Quintic interpolation (less banding than cubic)\n    f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);\n    \n    uvec2 ui = uvec2(i);\n    float a = toGaussian(ui);\n    float b = toGaussian(ui + uvec2(1u, 0u));\n    float c = toGaussian(ui + uvec2(0u, 1u));\n    float d = toGaussian(ui + uvec2(1u, 1u));\n    \n    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);\n}\n\nfloat smoothNoise(vec2 p, uint offset) {\n    vec2 i = floor(p);\n    vec2 f = fract(p);\n    \n    f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);\n    \n    uvec2 ui = uvec2(i);\n    float a = toGaussian(ui, offset);\n    float b = toGaussian(ui + uvec2(1u, 0u), offset);\n    float c = toGaussian(ui + uvec2(0u, 1u), offset);\n    float d = toGaussian(ui + uvec2(1u, 1u), offset);\n    \n    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);\n}\n\nvoid main() {\n    vec4 color = texture(u_image0, v_texCoord);\n    \n    // Luminance (Rec.709)\n    float luma = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));\n    \n    // Grain UV (resolution-independent)\n    vec2 grainUV = v_texCoord * u_resolution / max(u_float1, 0.01);\n    uvec2 grainPixel = uvec2(grainUV);\n    \n    float g;\n    vec3 grainRGB;\n    \n    if (u_int0 == 1) {\n        // Grainy mode: pure hash noise (no interpolation = no banding)\n        g = toGaussian(grainPixel);\n        grainRGB = vec3(\n            toGaussian(grainPixel, 100u),\n            toGaussian(grainPixel, 200u),\n            toGaussian(grainPixel, 300u)\n        );\n    } else {\n        // Smooth mode: interpolated with quintic curve\n        g = smoothNoise(grainUV);\n        grainRGB = vec3(\n            smoothNoise(grainUV, 100u),\n            smoothNoise(grainUV, 200u),\n            smoothNoise(grainUV, 300u)\n        );\n    }\n    \n    // Luminance weighting (less grain in highlights)\n    float lumWeight = mix(1.0, 1.0 - luma, clamp(u_float3, 0.0, 1.0));\n    \n    // Strength\n    float strength = u_float0 * 0.15;\n    \n    // Color vs monochrome grain\n    vec3 grainColor = mix(vec3(g), grainRGB, clamp(u_float2, 0.0, 1.0));\n    \n    color.rgb += grainColor * strength * lumWeight;\n    fragColor0 = vec4(clamp(color.rgb, 0.0, 1.0), color.a);\n}\n",
      "size_mode": "from_input",
      "images.image0": [
        "34",
        0
      ],
      "floats.u_float0": [
        "35:17",
        0
      ],
      "floats.u_float1": [
        "35:18",
        0
      ],
      "floats.u_float2": [
        "35:19",
        0
      ],
      "floats.u_float3": [
        "35:20",
        0
      ],
      "ints.u_int0": [
        "35:21",
        1
      ]
    },
    "class_type": "GLSLShader",
    "_meta": {
      "title": "GLSLシェーダー"
    }
  }
}', FALSE
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'api' AND w.workflow_name = 'lotta-IPAdapter9_ultra_upscale_fd4.json');

-- Lotta: template workflow templates/workflow_args.json
INSERT INTO personyx.persona_workflow_overrides (persona_id, workflow_kind, workflow_name, workflow_json, is_default)
SELECT p.id, 'template', 'workflow_args.json', '{
    "modifications": [
        {
            "node_id": "12",
            "condition": {
                "class_type": "CLIPTextEncode"
            },
            "modifications": {
                "inputs": {
                    "text": "${positive_prompt}"
                }
            }
        },
        {
            "node_id": "13",
            "condition": {
                "class_type": "CLIPTextEncode"
            },
            "modifications": {
                "inputs": {
                    "text": "${negative_prompt}"
                }
            }
        },
        {
            "node_id": "6",
            "condition": {
                "class_type": "EmptyLatentImage"
            },
            "modifications": {
                "inputs": {
                    "width": "${image_width}",
                    "height": "${image_height}",
                    "batch_size": "${batch_size}"
                }
            }
        },
        {
            "node_id": "5",
            "condition": {
                "class_type": "KSampler"
            },
            "modifications": {
                "inputs": {
                    "seed": "${random_seed}"
                }
            }
        },
        {
            "node_id": "31",
            "condition": {
                "class_type": "CLIPTextEncode"
            },
            "modifications": {
                "inputs": {
                    "text": "${face_detailer_positive_prompt}"
                }
            }
        },
        {
            "node_id": "32",
            "condition": {
                "class_type": "CLIPTextEncode"
            },
            "modifications": {
                "inputs": {
                    "text": "${face_detailer_negative_prompt}"
                }
            }
        }
    ]
}
', FALSE
FROM personyx.personas p
WHERE p.name = 'Lotta'
  AND NOT EXISTS (SELECT 1 FROM personyx.persona_workflow_overrides w WHERE w.persona_id = p.id AND w.workflow_kind = 'template' AND w.workflow_name = 'workflow_args.json');

COMMIT;
