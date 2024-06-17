# Stage 1: Build Angular frontend
FROM node:14 AS ANGULAR_BUILD
RUN npm install -g @angular/cli@12.0.0
COPY webapp /webapp
WORKDIR /webapp
RUN npm install && ng build --prod

# Stage 2: Build Go backend
FROM golang:1.17-alpine AS GO_BUILD
COPY server /server
WORKDIR /server
RUN go build -o /go/bin/server

# Stage 3: Final image with Alpine and Caddy
FROM alpine:latest


# Copy built Angular frontend and Go binary from previous stages
COPY --from=ANGULAR_BUILD /webapp/dist/webapp /app/webapp/dist/webapp
COPY --from=GO_BUILD /go/bin/server /app/

WORKDIR app
COPY --from=ANGULAR_BUILD /webapp/dist/webapp/* ./webapp/dist/webapp/
COPY --from=GO_BUILD /go/bin/server ./
RUN ls

EXPOSE 8080
CMD ./server