from ultralytics import YOLO

# Load a model
#model = YOLO('runs/detect/train4/weights/best.pt')  # pretrained YOLOv8n model
model = YOLO('runs/detect/tune2/weights/best.pt')  # pretrained YOLOv8n model

# Run batched inference on a list of images
results = model(['test_images/testimg1.jpg', 'test_images/testimg2.jpg'], save=True, project="runs/detect", name="inference")  # return a list of Results objects

# Process results list
for result in results:
    boxes = result.boxes  # Boxes object for bbox outputs
    masks = result.masks  # Masks object for segmentation masks outputs
    keypoints = result.keypoints  # Keypoints object for pose outputs
    probs = result.probs  # Probs object for classification outputs
