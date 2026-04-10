FROM nginx:alpine

# Remove default nginx static files (website content)
RUN rm -rf /usr/share/nginx/html/*

# Copy app files to nginx folder
COPY index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx
CMD [ "nginx", "-g", "daemon off;" ]