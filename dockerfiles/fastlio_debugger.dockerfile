FROM osrf/ros:humble-desktop

ARG UBUNTU_MIRROR=http://mirrors.tuna.tsinghua.edu.cn/ubuntu
RUN sed -i "s|http://archive.ubuntu.com/ubuntu|${UBUNTU_MIRROR}|g" /etc/apt/sources.list

ENV DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    ros-humble-pcl-ros ros-humble-pcl-conversions

COPY dockerfiles/fastlio_rviz_entrypoint.sh /fastlio_rviz_entrypoint.sh
RUN chmod +x /fastlio_rviz_entrypoint.sh

ENTRYPOINT ["/fastlio_rviz_entrypoint.sh"]
CMD ["rviz2"]
