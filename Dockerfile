FROM debian:bookworm-slim

# ป้องกันคำถามระหว่างการติดตั้งแพ็กเกจ / Prevent interactive package prompts
ENV DEBIAN_FRONTEND=noninteractive

# ติดตั้ง XeLaTeX และเครื่องมือที่แม่แบบต้องใช้ / Install XeLaTeX and template build tools
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        latexmk \
        texlive-latex-extra \
        texlive-lang-other \
        texlive-xetex \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# ใช้ latexmk เพื่อคอมไพล์ซ้ำจนสารบัญและเลขอ้างอิงอัปเดต / Let latexmk rerun until references stabilize
ENTRYPOINT ["latexmk"]
CMD ["-xelatex", "-interaction=nonstopmode", "-halt-on-error", "main.tex"]
