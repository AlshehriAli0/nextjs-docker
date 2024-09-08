# Next.js Docker Template

This repository provides a Docker setup for a Next.js application, using `pnpm` for package management. It includes a multi-stage Dockerfile to build and run a Next.js application efficiently.

## Features

- **Multi-stage Docker Build**: Reduces final image size and improves security by separating the build and runtime environments.
- **`pnpm` Package Management**: Uses `pnpm` for faster, more efficient dependency management.
- **Optional Public Directory**: Handles the optional presence of the `public` directory gracefully.

## Getting Started

### Prerequisites

Ensure you have the following installed on your local machine:

- [Docker](https://docs.docker.com/get-docker/)
- [pnpm](https://pnpm.io/)

### Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/your-username/nextjs-docker.git
   cd nextjs-docker
   ```

2. **Install Dependencies**

   If you haven't already installed dependencies using `pnpm`, you can do so with:

   ```bash
   pnpm install
   ```

### Docker Setup

1. **Build the Docker Image**

   To build the Docker image, use the following command:

   ```bash
   pnpm run docker:build
   ```

2. **Run the Docker Container**

   To build and run the Docker container, use:

   ```bash
   pnpm run docker:start
   ```

   This will map port 3000 from the container to port 3000 on your host machine.

### Dockerfile Explanation

- **Base Image**: Uses Node.js 20 on Alpine Linux.
- **Builder Stage**:
  - Sets up the working directory.
  - Copies `package.json` and `pnpm-lock.yaml` and installs dependencies using `pnpm`.
  - Copies the source code from `src` directory and builds the Next.js application.
- **Runner Stage**:
  - Sets up a lightweight runtime environment.
  - Creates a system user and group for security.
  - Copies the build artifacts and necessary files from the builder stage.
  - Runs the Next.js application.

### Customization

You can customize the Dockerfile for your specific needs by:
- Adjusting the `COPY` commands if your project structure differs.
- Adding environment variables for secrets using `ARG`.
- Modifying `CMD` if you use a different entry point for your application.

### Troubleshooting

- **Missing `public` Directory**: If the `public` directory is not present, Docker will proceed without it, and no build errors will occur.
- **Docker Errors**: Ensure Docker and `pnpm` are correctly installed and updated.

### Contributing

Feel free to contribute by creating pull requests or opening issues. For significant changes, please discuss them first by opening an issue.

### License

This project is licensed under the [MIT License](LICENSE).

---

For more details, check the [Next.js documentation](https://nextjs.org/docs) and [Docker documentation](https://docs.docker.com/).
