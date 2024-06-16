from ultralytics import YOLO

# Initialize the YOLO model
model = YOLO('yolov8n.pt')

# Tune hyperparameters on COCO8 for 30 epochs
model.tune(data='config.yaml', epochs=30, optimizer='AdamW', plots=False, save=False, val=False)
