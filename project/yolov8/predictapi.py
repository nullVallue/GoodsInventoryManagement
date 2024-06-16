from ultralytics import YOLO
from flask import Flask, request, jsonify
from PIL import Image
from PIL import ImageOps 
from io import BytesIO
import base64
import os


app = Flask(__name__)


def predict_yolo(image_data):

    decoded_image = base64.b64decode(image_data)

    # Open image using PIL
    imgbyte = Image.open(BytesIO(decoded_image))

    outputDir = 'temp/'
    saveFileName = 'temp.jpg'

    os.makedirs(outputDir, exist_ok = True)

    outputPath = os.path.join(outputDir, saveFileName)

    imgbyte.save(outputPath)

    img = Image.open(outputPath)

    # Load a model
    #model = YOLO('runs/detect/train4/weights/best.pt')  # pretrained YOLOv8n model
    #model = YOLO('runs/detect/train29/weights/best.pt')  # pretrained YOLOv8n model
    model = YOLO('runs/detect/train40/weights/best.pt')  # pretrained YOLOv8n model

    # Run batched inference on a list of images
    # results = model(img, save=True, project="runs/detect", name="inference",)  # return a list of Results objects
    results = model(img, save=True, project="runs/detect", name="inference", conf=0.65, show_labels=False)  # return a list of Results objects

    imgPath = ''
    length = 0

    # Process results list
    for result in results:
        boxes = result.boxes  # Boxes object for bbox outputs
        masks = result.masks  # Masks object for segmentation masks outputs
        keypoints = result.keypoints  # Keypoints object for pose outputs
        probs = result.probs  # Probs object for classification outputs

        # imgPath = result.path
        if result.__len__() > length:
            length = result.__len__()

        # length += result.__len__()


    latestFolder = find_highest_numbered_folder('runs/detect')

    imgPath = 'runs/detect/' + latestFolder + '/' + saveFileName
    
    image = Image.open(imgPath)
    image = ImageOps.exif_transpose(image)
    # image = image.rotate(90, expand=True)

    image_bytes_io = BytesIO()
    image.save(image_bytes_io, format='JPEG')
    image_bytes = image_bytes_io.getvalue()

    # imageData = base64.b64encode(image_buffer.getvalue()).decode('utf-8')
    imageData = base64.b64encode(image_bytes).decode('utf-8') 

    return [imageData, length] 

def find_highest_numbered_folder(path):
    # Get a list of all directories in the specified path
    dirs = [d for d in os.listdir(path) if os.path.isdir(os.path.join(path, d))]

    # Initialize variables to track the highest number and corresponding folder
    highest_number = 0
    highest_folder = None

    # Iterate through each directory
    for folder in dirs:
        try:
            # Extract the numeric part from the folder name
            folder_number = int(folder.split('inference')[-1])
            
            # Check if the current folder number is higher than the highest recorded
            if folder_number > highest_number:
                highest_number = folder_number
                highest_folder = folder
        except ValueError:
            # Skip folders that don't have a valid numeric part
            continue

    return highest_folder


@app.route('/predict', methods=['POST'])
def predict():
    try:

        data = request.get_json()
        image_data = data['image']

        resultArray = predict_yolo(image_data)

        result_image = resultArray[0] 
        result_len = resultArray[1]

        # predict_image = Image.open(predict_image_path)
        response_data = {
            'resultImage' : result_image,
            'length' : result_len,
        }

        return jsonify(response_data)

    except Exception as e:
        print(str(e))
        return jsonify({'error' : str(e)}), 500


if __name__ == '__main__':
    app.run(debug=False, port=8081, host='0.0.0.0') 
